Shader "Custom/alphaTesting"
{
    Properties
    {
        // ��������� �ʴ� _Color ������Ƽ�� �߰��� ������, 
        // �� ������ �׸��� ������ �ʿ��� �ϴ��� FallBack ���̴��� ���Ǵ� �����̱� ����!
        _Color ("Main Color", Color) = (1, 1, 1, 1) 
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5 // �����׽�Ʈ�� ����� Cutoff ���ذ��� �������̽��� �ޱ� ���� ������Ƽ �߰���.
    }
    SubShader
    {
        // �����׽�Ʈ ���̴��� ��ȯ�ϱ� ���� Tags ���� 
        // Queue �� AlphaTest �� ������ ���, �� ���̴��� ����� ������Ʈ��
        // �Ϲ� ������ ������Ʈ�� ������ ������Ʈ(���� ���� ���̴��� ������ ������Ʈ) ���̿� �׷����� ��.
        // ��, �Ϲ� ������ ������Ʈ -> �����׽�Ʈ ������Ʈ -> ���ĺ��� ������Ʈ ������ �׷����� �ȴٴ� ��.
        // �ڷᱸ������ ���ϴ� Queue �� ����� ������ �� �ϸ�, �׷����� ������Ʈ�� ������ ť ������ ������ �� ����.
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
        cull off // �� �߷����⸦ ��Ȱ��ȭ�ؼ� Ǯ �ؽ��ĸ� ���� Quad �� ����� ��� �������� �� �ֵ��� ��.

        CGPROGRAM

        // Lambert ����Ʈ �⺻������ ����
        // �ƿ��� ���ذ��� �������̽��� ���� ������ alphatest: �� �־��ָ�
        // �ش� �ƿ��� ���ذ����� ���� ���İ��� ��������, ū ���İ��� ���İ� ���� ��ó��, �� ���� �������ϰ� ������ ��.
        // -> ���̴� �ڵ� �Թ����� �����׽�Ʈ ���� ������ �� �����ϱ�
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
    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit" // Cutout ���丮�� ����� ���̴� �� �ϳ��� �������� Ǯ �ؽ����� �׸��ڸ� �׷��� �� ����
}
