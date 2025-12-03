export interface Env {
  GEMINI_API_KEY: string;
}

interface Wave {
  content: string;
  createdAt: string;
}

interface SwellResponse {
  summary: string;
  reflection: string;
}

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

export default {
  async fetch(
    request: Request,
    env: Env,
    ctx: ExecutionContext,
  ): Promise<Response> {
    // Handle CORS preflight
    if (request.method === "OPTIONS") {
      return new Response(null, { headers: CORS_HEADERS });
    }

    if (request.method !== "POST") {
      return new Response("Method Not Allowed", {
        status: 405,
        headers: CORS_HEADERS,
      });
    }

    try {
      const body = (await request.json()) as { waves: Wave[] };
      const waves = body.waves;

      if (!waves || waves.length === 0) {
        return new Response(JSON.stringify({ error: "No waves provided" }), {
          status: 400,
          headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
        });
      }

      const prompt = `
You are a thoughtful reflection assistant. The user has written these waves over the past 24 hours:

<waves>
${JSON.stringify(waves)}
</waves>

Generate:
1. A 2-3 sentence summary of what's on their mind
2. One gentle, open-ended reflective question

Keep tone warm but not saccharine. Be specific to their actual waves, not generic.
Do not give advice unless explicitly relevant. Focus on reflection.
Ensure the combined length of the summary and reflection is a maximum of 80 words.

Respond in JSON:
{
  "summary": "...",
  "reflection": "..."
}
`;

      const geminiResponse = await fetch(
        `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-goog-api-key": env.GEMINI_API_KEY,
          },
          body: JSON.stringify({
            contents: [
              {
                parts: [{ text: prompt }],
              },
            ],
            generationConfig: {
              responseMimeType: "application/json",
            },
          }),
        },
      );

      if (!geminiResponse.ok) {
        const errorText = await geminiResponse.text();
        console.error("Gemini API Error:", errorText);
        throw new Error(`Gemini API failed: ${geminiResponse.status}`);
      }

      const data = (await geminiResponse.json()) as any;
      const textResponse = data.candidates[0].content.parts[0].text;
      const swell: SwellResponse = JSON.parse(textResponse);

      return new Response(JSON.stringify(swell), {
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      });
    } catch (error) {
      console.error("Worker Error:", error);
      return new Response(JSON.stringify({ error: "Internal Server Error" }), {
        status: 500,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      });
    }
  },
};
