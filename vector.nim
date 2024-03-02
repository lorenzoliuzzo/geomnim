import std/math    

type 
    ## Define a generic vector type with a fixed size and element type.
    Vec*[N: static[int], V] = array[N, V]

    ## Define vector type aliases for common size and element type vectors.
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


proc zero*[N: static[int], T](_: typedesc[Vec[N, T]]): Vec[N, T] = 
    for i in 0..<N:
        result[i] = T(0)

proc fill*[N: static[int], T](_: typedesc[Vec[N, T]], val: T): Vec[N, T] = 
    for i in 0..<N:
        result[i] = val

proc rand*[N: static[int], T](_: typedesc[Vec[N, T]], max: T): Vec[N, T] = 
    for i in 0..<N:
        result[i] = rand(max)

proc cat*[M, N: static[int], T](a: Vec[M, T], b: Vec[N, T]): Vec[M + N, T] =
    for i in 0..<M:
        result[i] = a[i]
    for i in 0..<N:
        result[i + M] = b[i]

proc dot2*[N: static[int], T](a, b: Vec[N, T]): T =
    for i in 0..<N:
        result += a[i] * b[i]

proc norm2*[N: static[int], T](a: Vec[N, T]): T {.inline} = dot2(a, a)

proc dist2*[N: static[int], T](at, to: Vec[N, T]): T {.inline} = (at - to).norm2

proc dot*[N: static[int], T](a, b: Vec[N, T]): float {.inline} = sqrt(dot2(a, b).float)

proc norm*[N: static[int], T](a: Vec[N, T]): float {.inline} = dot(a, a)

proc dist*[N: static[int], T](at, to: Vec[N, T]): float {.inline} = (at - to).norm

proc normalize*[N: static[int], T](a: Vec[N, T]): Vec[N, T] {.inline} = a / a.norm

proc dir*[N: static[int], T](at, to: Vec[N, T]): Vec[N, T] {.inline} = (at - to).normalize

proc dir*(theta: float): Vec2f {.inline} = Vec2f([cos(theta), sin(theta)])

proc dir*(theta, phi: float): Vec3f {.inline} = Vec3f([sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi)])

proc angle*[T](a, b: Vec[2, T] | Vec[3, T]): float {.inline} = arccos(dot(a, b) / (a.norm * b.norm)) 

proc cross*[T](a, b: Vec3[T]): Vec3[T] =
    for i in 0..2:
        result[i] = a[(i + 1) mod 3] * b[(i + 2) mod 3] - a[(i + 2) mod 3] * b[(i + 1) mod 3]

proc mix*[N: static[int], T](a, b: Vec[N, T], v: float): Vec[N, T] {.inline} = a * (1.0 - v) + b * v