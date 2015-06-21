texture Tex;

technique signtexture
{
    pass P0
    {
        Texture[0] = Tex;

		AlphaBlendEnable = TRUE;
    }
}
