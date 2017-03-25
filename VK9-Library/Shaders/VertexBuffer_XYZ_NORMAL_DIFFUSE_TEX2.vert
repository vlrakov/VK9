/*
Copyright(c) 2016 Christopher Joseph Dean Schaefer

This software is provided 'as-is', without any express or implied
warranty.In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions :

1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software.If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

#version 400
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

#define D3DSHADE_FLAT 1
#define D3DSHADE_GOURAUD 2
#define D3DSHADE_PHONG 3

#define D3DLIGHT_POINT 1
#define D3DLIGHT_SPOT 2
#define D3DLIGHT_DIRECTIONAL 3

layout(constant_id = 0) const int lightCount = 0;
layout(constant_id = 1) const int shadeMode = D3DSHADE_GOURAUD;

#if lightCount > 0
	struct Light
	{
		int        Type;            /* Type of light source */
		vec4       Diffuse;         /* Diffuse color of light */
		vec4       Specular;        /* Specular color of light */
		vec4       Ambient;         /* Ambient color of light */
		vec3       Position;        /* Position in world space */
		vec3       Direction;       /* Direction in world space */
		float      Range;           /* Cutoff range */
		float      Falloff;         /* Falloff */
		float      Attenuation0;    /* Constant attenuation */
		float      Attenuation1;    /* Linear attenuation */
		float      Attenuation2;    /* Quadratic attenuation */
		float      Theta;           /* Inner angle of spotlight cone */
		float      Phi;             /* Outer angle of spotlight cone */
	};
 
	struct Material
	{
		vec4   Diffuse;        /* Diffuse color RGBA */
		vec4   Ambient;        /* Ambient color RGB */
		vec4   Specular;       /* Specular 'shininess' */
		vec4   Emissive;       /* Emissive color RGB */
		float  Power;          /* Sharpness if specular highlight */
	};

	layout(binding = 1) uniform Material material;
	layout(binding = 2) uniform Light lights[lightCount];

	vec3 getGouradLight( int lightIndex, vec3 position, vec3 norm )
	{
		vec3 s = normalize( vec3( lights[lightIndex].Position - position ) );
		vec3 v = normalize( -position.xyz );
		vec3 r = reflect( -s, norm );
 
		vec3 ambient = Light[lightIndex].Ambient * material.Ambient;
 
		float sDotN = max( dot( s, norm ), 0.0 );
		vec3 diffuse = lights[lightIndex].Diffuse * material.Diffuse * sDotN;
 
		vec3 spec = vec3( 0.0 );
		if ( sDotN > 0.0 )
			spec = lights[lightIndex].Specular * material.Specular * pow( max( dot(r,v) , 0.0 ), material.Power );
 
		return ambient + diffuse + spec;
	}

#endif

layout(push_constant) uniform UniformBufferObject {
    mat4 totalTransformation;
} ubo;

layout (location = 0) in vec4 position;
layout (location = 1) in vec4 attr1; //normal
layout (location = 2) in uvec4 attr2; //color
layout (location = 3) in vec2 attr3; //tex1
layout (location = 4) in vec2 attr4; //tex2

layout (location = 0) out vec4 normal;
layout (location = 1) out vec4 color;
layout (location = 2) out vec2 texcoord1;
layout (location = 3) out vec2 texcoord2;

out gl_PerVertex 
{
	vec4 gl_Position;
};

vec4 Convert(uvec4 rgba)
{
	vec4 unpacked;

	unpacked.w = float(rgba.w);
	unpacked.z = float(rgba.z);
	unpacked.y = float(rgba.y);
	unpacked.x = float(rgba.x);

	unpacked.x = unpacked.x / 255;
	unpacked.y = unpacked.y / 255;
	unpacked.z = unpacked.z / 255;
	unpacked.w = unpacked.w / 255;	

	return unpacked;
}

void main() 
{
	gl_Position = ubo.totalTransformation * position * vec4(1.0,-1.0,1.0,1.0);

	normal = attr1;
	color = Convert(attr2);
	texcoord1 = attr3;
	texcoord2 = attr4;

	#if lightCount > 0
		#if shadeMode = D3DSHADE_GOURAUD
		for( int i=0; i<lightCount; ++i )
		{
			color += getGouradLight( i, gl_Position, normal);
		}
		#endif
	#endif
}
