import std/[math, random]    

type 
    Vec*[N: static[int], V] = array[N, V]
    ## Define a generic vector type with a fixed size and element type.

    Vec2*[V] = Vec[2, V]
    Vec3*[V] = Vec[3, V]
    Vec4*[V] = Vec[4, V]
    Vec2i* = Vec2[int]
    Vec3i* = Vec3[int]
    Vec4i* = Vec4[int]
    Vec2f* = Vec2[float]
    Vec3f* = Vec3[float]
    Vec4f* = Vec4[float]


template VecOp(op: untyped) =
    ## Template for performing element-wise operations on vectors.
    
    proc op*[N: static[int], T](a: Vec[N, T], b: T): Vec[N, T] =
        for i in 0..<N: 
            result[i] = op(a[i], b)

    proc op*[N: static[int], T](a: T, b: Vec[N, T]): Vec[N, T] =
        for i in 0..<N: 
            result[i] = op(a, b[i])    

    proc op*[N: static[int], T](a, b: Vec[N, T]): Vec[N, T] =
        for i in 0..<N: 
            result[i] = op(a[i], b[i])  

VecOp(`+`)
VecOp(`-`)
VecOp(`*`)
VecOp(`/`)
VecOp(`div`)
VecOp(`mod`)
VecOp(min)
VecOp(max)


template VecIncrOp(op: untyped) =
    ## Template for performing element-wise increment operations on vectors.

    proc op*[N: static[int], T](a: var Vec[N, T], b: T) =
        for i in 0..<N:
            op(a[i], b)

    proc op*[N: static[int], T](a: var Vec[N, T], b: Vec[N, T]) =
        for i in 0..<N:
            op(a[i], b[i])

VecIncrOp(`+=`)
VecIncrOp(`-=`)
VecIncrOp(`*=`)
VecIncrOp(`/=`)


template VecBoolOp(op: untyped) =

    proc op*[N: static[int], T](a, b: Vec[N, T]): Vec[N, bool] = 
        for i in 0..<N:
            result[i] = op(a[i], b[i])
    
    proc op*[N: static[int], T](a: Vec[N, T], b: T): Vec[N, bool] = 
        for i in 0..<N:
            result[i] = op(a[i], b)
    
VecBoolOp(`>`)
VecBoolOp(`<`)
VecBoolOp(`>=`)
VecBoolOp(`<=`)


template VecUnaryOp(op: untyped) = 
    ## Template for performing element-wise unary operations on vectors.

    proc op*[N: static[int], T](a: Vec[N, T]): Vec[N, T] =
        for i in 0..<N: 
            result[i] = op(a[i])    

VecUnaryOp(`-`)
VecUnaryOp(sin)
VecUnaryOp(cos)
VecUnaryOp(tan)
VecUnaryOp(sinh)
VecUnaryOp(cosh)
VecUnaryOp(tanh)
VecUnaryOp(arcsin)
VecUnaryOp(arccos)
VecUnaryOp(arctan)
VecUnaryOp(arcsinh)
VecUnaryOp(arccosh)
VecUnaryOp(arctanh)
VecUnaryOp(exp)
VecUnaryOp(ln)
VecUnaryOp(exp2)
VecUnaryOp(log2)
VecUnaryOp(sqrt)
VecUnaryOp(inversesqrt)
VecUnaryOp(floor)
VecUnaryOp(ceil)
VecUnaryOp(abs)