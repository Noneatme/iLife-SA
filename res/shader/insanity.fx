texture screenSource;
texture negative;

float2 uvCenter 			= float2(0.5, 0.5);
float blurStrength 			= 0.05;
float Time : Time;
float refractonStrength 	= 30.0; // 20 - 60
float wobblingStrength	 	= 23;
float globalStrength		= -1.0;

float insanityStrength 		= 1.0;

float timeA					= 0.01;
 
sampler ScreenSampler = sampler_state
{
	Texture = (screenSource);
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU  = Mirror;
	AddressV  = Mirror;
};

sampler NegativeSampler = sampler_state
{
	Texture = (negative);
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU  = Mirror;
	AddressV  = Mirror;
};

static const float2 poisson[6] =
{
	float2(-0.326212f, -0.40581f),
	float2(-0.840144f, -0.07358f),
	float2(-0.695914f, 0.457137f),
	float2(-0.203345f, 0.620716f),
	float2(0.96234f, -0.194983f),
	float2(0.473434f, -0.480026f),
};


float4 PixelShaderInsanity(float2 TextureCoordinates : TEXCOORD) : COLOR
{
	float4 colorOriginal = tex2D(ScreenSampler, TextureCoordinates);
	float2 distortCoords = TextureCoordinates;
	
	float2 coordsDelta = {sin(Time + distortCoords.x * wobblingStrength + distortCoords.y * distortCoords.y * wobblingStrength) * timeA , cos(Time + distortCoords.y + distortCoords.x * wobblingStrength * distortCoords.x) * 0.02};
	float2 newUVCoords = distortCoords + coordsDelta;
	float4 colorDistortion = 0;
	
	float2 blurCoords = TextureCoordinates;
	blurCoords -= uvCenter;
	float4 colorBlur = 0;
	
	for (int i = 0; i < 6; i ++)  {
		float scale = 1.0 + blurStrength * (i / 5.0);
		colorBlur += tex2D(ScreenSampler, blurCoords * scale + uvCenter) / 6;
		
		float2 Coord = newUVCoords + (poisson[i] / refractonStrength);
		colorDistortion += tex2D(ScreenSampler, Coord) / 6;
	}
	
	float4 colorVignette = tex2D(ScreenSampler, TextureCoordinates);
	
	float4 effectColor = (colorDistortion + colorBlur) * colorVignette.a;
	
	return (effectColor * insanityStrength) + (colorOriginal * (globalStrength - insanityStrength));
}


technique Insanity
{
    pass P0
    {
        PixelShader  = compile ps_2_0 PixelShaderInsanity();
    }
}