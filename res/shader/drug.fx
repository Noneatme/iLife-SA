texture screenSource;
float4 shaderColor = float4(1.0, 1.0, 1.0, 1.0);
float blurStrength;
float2 uvCenter = float2(0.5, 0.5);
float fadeValue = 0;
float vignetteStrength = 0.5;
float vignetteRadius = 0.5;
bool blurEnabled = false;
bool invertedColors = false;
bool singleColorEffect = false;
bool showVignette = false;
bool increaseColors = false;
bool switchColors = false;

sampler TextureSampler = sampler_state
{
    Texture = <screenSource>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};

float4 invertColor(float4 color)
{
	color = float4(color.a - color.rgb, color.a);
	
	return color;
}

float4 switchColor(float4 color)
{
	float tempRed = color.r;
		
	color.r = color.b;
	color.b = color.g;
	color.g = tempRed;
	
	return color;
}

float4 increaseColor(float4 color)
{
	float4 tempColor = color;
	
	color.rgb *= (color.g * color.g) * 2;
	color.rgb *= tempColor.rgb;
	
	return color + tempColor;
}

float4 DrugPixelShader(float2 TextureCoordinate : TEXCOORD0) : COLOR0
{	
	float4 color1 = tex2D(TextureSampler, TextureCoordinate);
	float4 color2 = tex2D(TextureSampler, TextureCoordinate);
	
	if (blurEnabled == true) {
		TextureCoordinate -= uvCenter;

		for (int i = 0; i < 16; i++)  {
			float scale = 1.0 + blurStrength * (i / 15.0);
			color1 += tex2D(TextureSampler, TextureCoordinate * scale + uvCenter);
		}
		   
		color1 /= 16;
	}
	
	if (invertedColors == true) {
		color1 = invertColor(color1);
	}
	
	if (switchColors == true) {
		color1 = switchColor(color1);
	}
	
	if (increaseColors == true) {
		color1 = increaseColor(color1);
	}
	
	if (singleColorEffect == true) {
		float value = (color1.r + color1.g + color1.b) / 3;
		color1.r = value;
		color1.g = value;
		color1.b = value;
		
		color1 *= shaderColor;
	}
	
	if (showVignette == true) {
		float v = length(TextureCoordinate) / vignetteRadius;
		color1.rgb -= pow(v, 4) * vignetteStrength;
	}
	
	float4 finalColor = (color2 * fadeValue) + (color1 * (1 - fadeValue));
	return finalColor;
}
 
technique DrugShaders
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 DrugPixelShader();
    }
}