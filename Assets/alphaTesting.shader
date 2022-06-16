Shader "Custom/alphaTesting"
{
    Properties
    {
        // 사용하지도 않는 _Color 프로퍼티를 추가한 이유는, 
        // 이 변수가 그림자 생성에 필요한 하단의 FallBack 쉐이더에 사용되는 변수이기 때문!
        _Color ("Main Color", Color) = (1, 1, 1, 1) 
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5 // 알파테스트에 사용할 Cutoff 기준값을 인터페이스로 받기 위해 프로퍼티 추가함.
    }
    SubShader
    {
        // 알파테스트 쉐이더로 변환하기 위한 Tags 설정 
        // Queue 를 AlphaTest 로 설정할 경우, 이 쉐이더가 적용된 오브젝트는
        // 일반 불투명 오브젝트와 반투명 오브젝트(알파 블렌딩 쉐이더를 적용한 오브젝트) 사이에 그려지게 됨.
        // 즉, 일반 불투명 오브젝트 -> 알파테스트 오브젝트 -> 알파블렌딩 오브젝트 순으로 그려지게 된다는 뜻.
        // 자료구조에서 말하는 Queue 의 개념과 동일한 듯 하며, 그려지는 오브젝트의 순서를 큐 구조로 정의한 것 같음.
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
        cull off // 면 추려내기를 비활성화해서 풀 텍스쳐를 입힌 Quad 의 양면이 모두 렌더링될 수 있도록 함.

        CGPROGRAM

        // Lambert 라이트 기본형으로 시작
        // 컷오프 기준값을 인터페이스로 받은 변수를 alphatest: 에 넣어주면
        // 해당 컷오프 기준값보다 작은 알파값은 안찍히고, 큰 알파값은 알파가 없는 것처럼, 즉 완전 불투명하게 찍히게 됨.
        // -> 셰이더 코딩 입문에서 알파테스트 직접 구현한 거 참고하기
        #pragma surface surf Lambert alphatest:_Cutoff 

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    // FallBack "Diffuse"
    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit" // Cutout 디렉토리에 저장된 쉐이더 중 하나를 가져오면 풀 텍스쳐의 그림자를 그려줄 수 있음
}
