// RUN: mlir-opt -split-input-file -verify-diagnostics %s | FileCheck %s

//===----------------------------------------------------------------------===//
// spirv.ImageDrefGather
//===----------------------------------------------------------------------===//

func.func @image_dref_gather(%arg0 : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32) -> () {
  // CHECK: spirv.ImageDrefGather {{.*}} : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, {{.*}} : vector<4xf32>, {{.*}} : f32 -> vector<4xi32>
  %0 = spirv.ImageDrefGather %arg0 : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32 -> vector<4xi32>
  spirv.Return
}

// -----

func.func @image_dref_gather_with_single_imageoperands(%arg0 : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32) -> () {
  // CHECK: spirv.ImageDrefGather {{.*}} ["NonPrivateTexel"] -> vector<4xi32>
  %0 = spirv.ImageDrefGather %arg0 : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32 ["NonPrivateTexel"] -> vector<4xi32>
  spirv.Return
}

// -----

func.func @image_dref_gather_with_mismatch_imageoperands(%arg0 : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32) -> () {
  // expected-error @+1 {{the Image Operands should encode what operands follow, as per Image Operands}}
  %0 = spirv.ImageDrefGather %arg0 : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32 (%arg2, %arg2 : f32, f32) -> vector<4xi32>
  spirv.Return
}

// -----

func.func @image_dref_gather_error_result_type(%arg0 : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32) -> () {
  // expected-error @+1 {{result type must be a vector of four components}}
  %0 = spirv.ImageDrefGather %arg0 : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32 -> vector<3xi32>
  spirv.Return
}

// -----

func.func @image_dref_gather_error_same_type(%arg0 : !spirv.sampled_image<!spirv.image<i32, Rect, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32) -> () {
  // expected-error @+1 {{the component type of result must be the same as sampled type of the underlying image type}}
  %0 = spirv.ImageDrefGather %arg0 : !spirv.sampled_image<!spirv.image<i32, Rect, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32 -> vector<4xf32>
  spirv.Return
}

// -----

func.func @image_dref_gather_error_dim(%arg0 : !spirv.sampled_image<!spirv.image<i32, Dim1D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32) -> () {
  // expected-error @+1 {{the Dim operand of the underlying image type must be 2D, Cube, or Rect}}
  %0 = spirv.ImageDrefGather %arg0 : !spirv.sampled_image<!spirv.image<i32, Dim1D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32 -> vector<4xi32>
  spirv.Return
}

// -----

func.func @image_dref_gather_error_ms(%arg0 : !spirv.sampled_image<!spirv.image<i32, Cube, NoDepth, NonArrayed, MultiSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32) -> () {
  // expected-error @+1 {{the MS operand of the underlying image type must be 0}}
  %0 = spirv.ImageDrefGather %arg0 : !spirv.sampled_image<!spirv.image<i32, Cube, NoDepth, NonArrayed, MultiSampled, NoSampler, Unknown>>, %arg1 : vector<4xf32>, %arg2 : f32 -> vector<4xi32>
  spirv.Return
}

// -----

//===----------------------------------------------------------------------===//
// spirv.Image
//===----------------------------------------------------------------------===//

func.func @image(%arg0 : !spirv.sampled_image<!spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NeedSampler, Unknown>>) -> () {
  // CHECK: spirv.Image {{.*}} : !spirv.sampled_image<!spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NeedSampler, Unknown>>
  %0 = spirv.Image %arg0 : !spirv.sampled_image<!spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NeedSampler, Unknown>>
  return
}

// -----

//===----------------------------------------------------------------------===//
// spirv.ImageQuerySize
//===----------------------------------------------------------------------===//

func.func @image_query_size(%arg0 : !spirv.image<f32, Dim1D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>) -> () {
  // CHECK:  {{%.*}} = spirv.ImageQuerySize %arg0 : !spirv.image<f32, Dim1D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown> -> i32
  %0 = spirv.ImageQuerySize %arg0 : !spirv.image<f32, Dim1D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown> -> i32
  spirv.Return
}

// -----

func.func @image_query_size_error_dim(%arg0 : !spirv.image<f32, SubpassData, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>) -> () {
  //  expected-error @+1 {{the Dim operand of the image type must be 1D, 2D, 3D, Buffer, Cube, or Rect}}
  %0 = spirv.ImageQuerySize %arg0 : !spirv.image<f32, SubpassData, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown> -> i32
  spirv.Return
}

// -----

func.func @image_query_size_error_dim_sample(%arg0 : !spirv.image<f32, Dim1D, NoDepth, NonArrayed, SingleSampled, NeedSampler, Unknown>) -> () {
  //  expected-error @+1 {{if Dim is 1D, 2D, 3D, or Cube, it must also have either an MS of 1 or a Sampled of 0 or 2}}
  %0 = spirv.ImageQuerySize %arg0 : !spirv.image<f32, Dim1D, NoDepth, NonArrayed, SingleSampled, NeedSampler, Unknown> -> i32
  spirv.Return
}

// -----

func.func @image_query_size_error_result1(%arg0 : !spirv.image<f32, Dim3D, NoDepth, Arrayed, SingleSampled, NoSampler, Unknown>) -> () {
  //  expected-error @+1 {{expected the result to have 4 component(s), but found 3 component(s)}}
  %0 = spirv.ImageQuerySize %arg0 : !spirv.image<f32, Dim3D, NoDepth, Arrayed, SingleSampled, NoSampler, Unknown> -> vector<3xi32>
  spirv.Return
}

// -----

func.func @image_query_size_error_result2(%arg0 : !spirv.image<f32, Buffer, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>) -> () {
  //  expected-error @+1 {{expected the result to have 1 component(s), but found 2 component(s)}}
  %0 = spirv.ImageQuerySize %arg0 : !spirv.image<f32, Buffer, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown> -> vector<2xi32>
  spirv.Return
}

// -----

//===----------------------------------------------------------------------===//
// spirv.ImageWrite
//===----------------------------------------------------------------------===//

func.func @image_write(%arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : vector<4xf32>) -> () {
  // CHECK:  spirv.ImageWrite %arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : vector<4xf32>
  spirv.ImageWrite %arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : vector<4xf32>
  spirv.Return
}

// -----

func.func @image_write_scalar_texel(%arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : f32) -> () {
  // CHECK:  spirv.ImageWrite %arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : f32
  spirv.ImageWrite %arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : f32
  spirv.Return
}

// -----

func.func @image_write_need_sampler(%arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NeedSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : vector<4xf32>) -> () {
  // expected-error @+1 {{the sampled operand of the underlying image must be 0 or 2}}
  spirv.ImageWrite %arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NeedSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : vector<4xf32>
  spirv.Return
}

// -----

func.func @image_write_subpass_data(%arg0 : !spirv.image<f32, SubpassData, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : vector<4xf32>) -> () {
  // expected-error @+1 {{the Dim operand of the underlying image must not be SubpassData}}
  spirv.ImageWrite %arg0 : !spirv.image<f32, SubpassData, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : vector<4xf32>
  spirv.Return
}

// -----

func.func @image_write_texel_type_mismatch(%arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : vector<4xi32>) -> () {
  // expected-error @+1 {{the texel component type must match the image sampled type}}
  spirv.ImageWrite %arg0 : !spirv.image<f32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Rgba16>, %arg1 : vector<2xsi32>, %arg2 : vector<4xi32>
  spirv.Return
}
