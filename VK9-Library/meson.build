# Based on DXVK build system -https://github.com/doitsujin/dxvk/blob/master/src/d3d11/meson.build
d3d9_src = [
  'BufferManager.cpp',
  'C9.cpp',
  'CBaseTexture9.cpp',
  'CCubeTexture9.cpp',
  'CDevice9.cpp',
  'CIndexBuffer9.cpp',
  'CPixelShader9.cpp',
  'CQuery9.cpp',
  'CRenderTargetSurface9.cpp',
  'CResource9.cpp',
  'CStateBlock9.cpp',
  'CSurface9.cpp',
  'CSwapChain9.cpp',
  'CTexture9.cpp',
  'CTypes.cpp',
  'CVertexBuffer9.cpp',
  'CVertexDeclaration9.cpp',
  'CVertexShader9.cpp',
  'CVolume9.cpp',
  'CVolumeTexture9.cpp',
  'D3D9.cpp',
  'dllmain.cpp',
  'DrawContext.cpp',
  'GarbageManager.cpp',
  'Perf_CommandStreamManager.cpp',
  'Perf_ProcessQueue.cpp',
  'Perf_RenderManager.cpp',
  'Perf_StateManager.cpp',
  'RealDevice.cpp',
  'RealIndexBuffer.cpp',
  'RealInstance.cpp',
  'RealSurface.cpp',
  'RealSwapChain.cpp',
  'RealTexture.cpp',
  'RealVertexBuffer.cpp',
  'RealWindow.cpp',
  'ResourceContext.cpp',
  'SamplerRequest.cpp',
  'ShaderConverter.cpp',
  'Utilities.cpp'
]

d3d9_dll = shared_library('d3d9', d3d9_src,
  name_prefix         : '',
  link_with           : [ ],
  dependencies        : [ boost_dep, vulkan_dep, eigen_dep ],
  cpp_args            : [ vulkan_defs, '-DSCHAEFERGLLIBRARY_EXPORTS' ],
  cpp_pch             : ['pch/stdafx.h', 'pch/stdafx.cpp'],
  install             : true,
  vs_module_defs      : 'd3d9.def',
  override_options    : ['cpp_std='+vk9_cpp_std])

d3d9_dep = declare_dependency(
  link_with           : [ d3d9_dll ],
  include_directories : [ include_directories('.') ])

subdir('Shaders')
