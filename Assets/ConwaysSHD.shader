Shader "Unlit/ConwaysSHD"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _Mask;
            float4    _Mask_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            float4 _MainTex_TexelSize;

            fixed4 frag(v2f i) : SV_Target
            {
                float2 BRuv = i.uv + _MainTex_TexelSize.xy;
                float2 Buv = i.uv + float2(0, _MainTex_TexelSize.y);
                float2 BLuv = i.uv + float2(-_MainTex_TexelSize.x, _MainTex_TexelSize.y);

                float2 TLuv = i.uv - _MainTex_TexelSize.xy;
                float2 Tuv = i.uv - float2(0, _MainTex_TexelSize.y);
                float2 TRuv = i.uv + float2(_MainTex_TexelSize.x, -_MainTex_TexelSize.y);

                float2 Ruv = i.uv + float2(_MainTex_TexelSize.x, 0);
                float2 Luv = i.uv - float2(_MainTex_TexelSize.x, 0);

                fixed4 BR = tex2D(_MainTex, BRuv);
                fixed4 B  = tex2D(_MainTex, Buv);
                fixed4 BL = tex2D(_MainTex, BLuv);

                fixed4 TR = tex2D(_MainTex, BRuv);
                fixed4 T  = tex2D(_MainTex, Buv);
                fixed4 TL = tex2D(_MainTex, BLuv);

                fixed4 R = tex2D(_MainTex, Ruv);
                fixed4 L = tex2D(_MainTex, Luv);

                int count = 0;
                fixed4 mid = fixed4(0.5, 0.5, 0.5, 0.5);
                count += BR > mid;
                count += B  > mid;
                count += BL > mid;

                count += TR > mid;
                count += T  > mid;
                count += TL > mid;

                count += R > mid;
                count += L > mid;

                fixed4 col = tex2D(_MainTex, i.uv) * (count > 3 || count < 2) + fixed4(1, 1, 1, 1) * count == 3;
                fixed4 mask = tex2D(_Mask, i.uv);
                
                return col * mask;
            }
            ENDCG
        }
    }
}
