#include<cuda_runtime.h>
#include<stdio.h>
#include<iostream>



//define the multithread action
__global__ void cube(float * d_out, float * d_in){
  int idx = threadIdx.x;
  float f = d_in[idx];
  d_out[idx] = f*f*f;
}

//start main activity
int main(int argc,char **argv){

  //initilize array specs
    const int ARRAY_SIZE = 96;
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

  //initalize array values
    float h_in[ARRAY_SIZE];
    for(int i=0;i<ARRAY_SIZE;i++){
        h_in[i]=float(i);
    }

  //print array
    std::cout<<"Before: \n";
    for(int i=0;i<ARRAY_SIZE;i++){
        printf("%f", h_in[i]);
        printf(((i%4)!=3) ? "\t" : "\n");
  }

    std::cout<<"\n";

  //initlize an array of the same size as our input
    float h_out[ARRAY_SIZE];

  //initalize the inputs to the multithread functiuon
    float * d_in;
    float * d_out;

  //allocate memory for the arrays
    cudaMalloc((void**) &d_in,ARRAY_BYTES);
    cudaMalloc((void**) &d_out,ARRAY_BYTES);

  //error check
  //std::cout<<cudaGetErrorString(cudaGetLastError())<<std::endl;

  //copy array from CPU to GPU to preform function on GPU's threads
    cudaMemcpy(d_in,h_in,ARRAY_BYTES,cudaMemcpyHostToDevice);
    cube<<<1,ARRAY_SIZE>>>(d_out,d_in);
  //copy result from function back from GPU to CPU 
    cudaMemcpy(h_out,d_out,ARRAY_BYTES,cudaMemcpyDeviceToHost);

  //print result array
    std::cout<<"\nAfter: \n";
    for(int i=0;i<ARRAY_SIZE;i++){
    printf("%f", h_out[i]);
    printf(((i%4)!=3) ? "\t" : "\n");
  }

    //free memory
    cudaFree(d_in);
    cudaFree(d_out);

  return 0;
}
