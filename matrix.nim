import vector
import std/random

type
    Mat*[M, N: static[int], V] = array[M, array[N, V]]
    SQMat*[N: static[int], V] = Mat[N, N, V]

    Mat2*[V] = SQMat[2, V]
    Mat3*[V] = SQMat[3, V]
    Mat4*[V] = SQMat[4, V]

    Mat2i* = Mat2[int]
    Mat3i* = Mat3[int]
    Mat4i* = Mat4[int]
    Mat2f* = Mat2[float]
    Mat3f* = Mat3[float]
    Mat4f* = Mat4[float]


template MatOp(op: untyped) =
    ## Template for performing element-wise operations on matrices.
    ## ToDo: 
    ##  - int vs float in matrix inversion because bad casting

    proc op*[M, N: static[int], V](a, b: Mat[M, N, V]): Mat[M, N, V] =
        for i in 0 ..< M: 
            for j in 0 ..< N:
                result[i][j] = op(a[i][j], b[i][j])    

    proc op*[M, N: static[int], V](a: Mat[M, N, V], b: V): Mat[M, N, V] =
        for i in 0 ..< M: 
            for j in 0 ..< N:
                result[i][j] = op(a[i][j], b)    

    proc op*[M, N: static[int], V](a: V, b: Mat[M, N, V]): Mat[M, N, V] =
        for i in 0 ..< M: 
            for j in 0 ..< N:
                result[i][j] = op(a, b[i][j])    

MatOp(`+`)
MatOp(`-`)
MatOp(`*`)
MatOp(`/`)
MatOp(`div`)
MatOp(`mod`)
MatOp(min)
MatOp(max)


template MatIncrOp(op: untyped) =
    ## Template for performing element-wise increment operations on matrices.

    proc op*[M, N: static[int], V](a: var Mat[M, N, V], b: V) =
        for i in 0 ..< M:
            for j in 0 ..< N:
                op(a[i][j], b)

    proc op*[M, N: static[int], V](a: var Mat[M, N, V], b: Mat[M, N, V]) =
        for i in 0 ..< M:
            for j in 0 ..< N:
                op(a[i][j], b[i][j])

MatIncrOp(`+=`)
MatIncrOp(`-=`)
MatIncrOp(`*=`)
MatIncrOp(`/=`)


template MatUnaryOp(op: untyped) = 
    ## Template for performing element-wise unary operations on matrices.

    proc op*[M, N: static[int], V](a: Mat[M, N, V]): Mat[M, N, V] =
        for i in 0 ..< M: 
            for j in 0 ..< N:
                result[i][j] = op(a[i][j])    

MatUnaryOp(`-`)
MatUnaryOp(sin)
MatUnaryOp(cos)
MatUnaryOp(tan)
MatUnaryOp(sinh)
MatUnaryOp(cosh)
MatUnaryOp(tanh)
MatUnaryOp(arcsin)
MatUnaryOp(arccos)
MatUnaryOp(arctan)
MatUnaryOp(arcsinh)
MatUnaryOp(arccosh)
MatUnaryOp(arctanh)
MatUnaryOp(exp)
MatUnaryOp(ln)
MatUnaryOp(exp2)
MatUnaryOp(log2)
MatUnaryOp(sqrt)
MatUnaryOp(inversesqrt)
MatUnaryOp(floor)
MatUnaryOp(ceil)
MatUnaryOp(abs)


template MatBoolOp(op: untyped) =

    proc op*[M, N: static[int], V](a, b: Mat[M, N, V]): Mat[M, N, bool] = 
        for i in 0 ..< M:
            for j in 0 ..< N:
                result[i][j] = op(a[i][j], b[i][j])
    
    proc op*[M, N: static[int], V](a: Mat[M, N, V], b: V): Mat[M, N, bool] = 
        for i in 0 ..< M:
            for j in 0 ..< N:
                result[i][j] = op(a[i][j], b)
    
MatBoolOp(`>`)
MatBoolOp(`<`)
MatBoolOp(`>=`)
MatBoolOp(`<=`)


proc id*[N: static[int], V](_: typedesc[SQMat[N, V]]): SQMat[N, V] = 
    for i in 0 ..< N:
        result[i][i] = V(1)

proc fill*[M, N: static[int], V](_: typedesc[Mat[M, N, V]], val: V): Mat[M, N, V] = 
    for i in 0 ..< M:
        for j in 0 ..< N:
            result[i][j] = val

proc rand*[M, N: static[int], V](_: typedesc[Mat[M, N, V]], max: V): Mat[M, N, V] = 
    for i in 0 ..< M:
        for j in 0 ..< N:
            result[i][j] = rand(max)


proc row*[M, N: static[int], V](mat: Mat[M, N, V], idx: int): Vec[N, V] = 
    for i in 0 ..< N:
        result[i] = mat[idx][i]

proc col*[M, N: static[int], V](mat: Mat[M, N, V], idx: int): Vec[M, V] = 
    for i in 0 ..< M:
        result[i] = mat[i][idx]

## ToDO:
##  - This not works if i use Mat
proc vstack*[M, N: static[int], V](mat: array[M, array[N, V]], vec: array[N, V]): array[M + 1, array[N, V]] =
    for j in 0 ..< N:
        for i in 0 ..< M:
            result[i][j] = mat[i][j]
        result[M][j] = vec[j]

proc vstack*[M, N, P: static[int], V](a: array[M, array[N, V]], b: array[P, array[N, V]]): array[M + P, array[N, V]] =
    for j in 0 ..< N:
        for i in 0 ..< M:
            result[i][j] = a[i][j]
        for i in 0 ..< P:
            result[i + M][j] = b[i][j]

proc hstack*[M, N: static[int], V](a: array[M, array[N, V]], vec: array[M, V]): array[M, array[N + 1, V]] =
    for i in 0 ..< M:
        for j in 0 ..< N:
            result[i][j] = a[i][j]
        result[i][N] = vec[i]

proc hstack*[M, N, P: static[int], V](a: array[M, array[N, V]], b: array[M, array[P, V]]): array[M, array[N + P, V]] =
    for i in 0 ..< M:
        for j in 0 ..< N:
            result[i][j] = a[i][j]
        for j in 0 ..< P:
            result[i][j + N] = b[i][j]


## ToDO: 
## Fix these bugs: Changing from array to Mat gives Error: 
##  unhandled exception: semtypinst.nim(260, 7) `result.kind notin nkCallKinds`  [AssertionDefect]
## The problem is in the return type: it works if i use arrays instead Mat for the return type.
# proc minor*[M:, N: static[int], V](m: Mat[M, N, V], row, col: int): Mat[M - 1, N - 1, V] =
proc minor*[M, N: static[int], V](m: Mat[M, N, V], row, col: int): array[M - 1, array[N - 1, V]] =
    for i in 0 ..< M - 1:
        for j in 0 ..< N - 1:
            result[i][j] = m[if i < row: i else: i + 1][if j < col: j else: j + 1]

proc cofactor[N: static[int], V](mat: SQMat[N, V], row, col: int): V {.inline} =
    return mat.minor(row, col).det * (if (row + col) mod 2 == 0: 1 else: -1)

proc cof*[N: static[int], V](mat: SQMat[N, V]): SQMat[N, V] =
    for i in 0 ..< N:
        for j in 0 ..< N:
            result[i][j] = mat.cofactor(i, j);

proc adj*[N: static[int], V](mat: SQMat[N, V]): SQMat[N, V] {.inline} = mat.cof.T


proc det*[N: static[int], V](m: SQMat[N, V]): V =
    ## ToDO: 
    ##  - Multidim determinant gives some errors: 
    ##     test.nim(222, 23): Check failed: mat5.det == -8, mat5.det was 4
    ##     test.nim(224, 24): Check failed: smat5.det == -2003, smat5.det was -2004
    when N == 1:
        return m[0][0]
    elif N == 2: 
        return m[0][0] * m[1][1] - m[0][1] * m[1][0]
    elif N == 3:
        return (
            m[0][0] * m[1][1] * m[2][2] + 
            m[0][1] * m[1][2] * m[2][0] + 
            m[0][2] * m[1][0] * m[2][1] - 
            m[0][2] * m[1][1] * m[2][0] - 
            m[0][1] * m[1][0] * m[2][2] - 
            m[0][0] * m[1][2] * m[2][1]
        )
    elif N == 4:
        return (
            m[3][0] * m[2][1] * m[1][2] * m[0][3]  -  m[2][0] * m[3][1] * m[1][2] * m[0][3]  -  m[3][0] * m[1][1] * m[2][2] * m[0][3]  +  m[1][0] * m[3][1] * m[2][2] * m[0][3] +
            m[2][0] * m[1][1] * m[3][2] * m[0][3]  -  m[1][0] * m[2][1] * m[3][2] * m[0][3]  -  m[3][0] * m[2][1] * m[0][2] * m[1][3]  +  m[2][0] * m[3][1] * m[0][2] * m[1][3] +
            m[3][0] * m[0][1] * m[2][2] * m[1][3]  -  m[0][0] * m[3][1] * m[2][2] * m[1][3]  -  m[2][0] * m[0][1] * m[3][2] * m[1][3]  +  m[0][0] * m[2][1] * m[3][2] * m[1][3] +
            m[3][0] * m[1][1] * m[0][2] * m[2][3]  -  m[1][0] * m[3][1] * m[0][2] * m[2][3]  -  m[3][0] * m[0][1] * m[1][2] * m[2][3]  +  m[0][0] * m[3][1] * m[1][2] * m[2][3] +
            m[1][0] * m[0][1] * m[3][2] * m[2][3]  -  m[0][0] * m[1][1] * m[3][2] * m[2][3]  -  m[2][0] * m[1][1] * m[0][2] * m[3][3]  +  m[1][0] * m[2][1] * m[0][2] * m[3][3] +
            m[2][0] * m[0][1] * m[1][2] * m[3][3]  -  m[0][0] * m[2][1] * m[1][2] * m[3][3]  -  m[1][0] * m[0][1] * m[2][2] * m[3][3]  +  m[0][0] * m[1][1] * m[2][2] * m[3][3] 
        )
    else:
        for i, x in m[0].pairs:
            result += x * m.cofactor(0, i)

proc tr*[N: static[int], T](mat: SQMat[N, T]): T = 
    for i in 0 ..< N:
        result += mat[i][i]

proc T*[M, N: static[int], V](mat: Mat[M, N, V]): Mat[N, M, V] = 
    for i in 0 ..< M:
        for j in 0 ..< N:
            result[j][i] = mat[i][j]
            
proc T*[N: static[int], V](vec: array[N, V]): Mat[N, 1, V] = 
    for i in 0 ..< N:
        result[i][0] = vec[i]


proc inv*[N: static[int], V](mat: SQMat[N, V]): SQMat[N, V] {.raises: [ValueError]} =
    let det = mat.det
    if det == 0:
        raise newException(ValueError, "Singular matrix, not invertible")
    when N == 1: 
        return 1.0 / mat
    elif N == 2:       
        return [[mat[1][1], -mat[0][1]], [-mat[1][0], mat[0][0]]] / det
    else:
        return mat.adj / det


proc dot*[M, N, P: static[int], T](a: Mat[M, N, T], b: Mat[N, P, T]): Mat[M, P, T] =
    for i in 0 ..< M:
        for j in 0 ..< P:
            for k in 0 ..< N:
                result[i][j] += a[i][k] * b[k][j]

proc dot*[M, N: static[int], T](a: Mat[M, N, T], b: Vec[N, T]): Vec[M, T] =
    for i in 0 ..< M:
        for j in 0 ..< N:
            result[i] += a[i][j] * b[j]

proc dot*[M, N: static[int], T](a: Vec[M, T], b: Mat[M, N, T]): Vec[N, T] =
    for i in 0 ..< M:
        for j in 0 ..< N:
            result[j] += a[i] * b[i][j]


proc LU*[N: static[int], V](m: SQMat[N, V]): tuple[lower: SQMat[N, V], upper: SQMat[N, V]] {.raises: [ValueError]} =
    var lower, upper: SQMat[N, V]

    for i in 0 ..< N:
        for j in 0 ..< i:
            if upper[j][j] == V(0):
                raise newException(ValueError, "No LU decomposition exists")

            var total: V
            for k in 0 ..< i:
                total += lower[i][k] * upper[k][j]

            lower[i][j] = (m[i][j] - total) / upper[j][j]

        lower[i][i] = V(1)

        for j in i ..< N:
            var total: V
            for k in 0 ..< i:
                total += lower[i][k] * upper[k][j]
            upper[i][j] = m[i][j] - total

    result = (lower, upper)


# proc gauss[N: static[int], V](A: Mat[N, N, V], b: Vec[N, V]): Vec[N] =
#     let Ab = [A.it]

# // /// @brief Solve the linear system Ax = b with the Gauss elimination method
# // friend constexpr auto gauss_solve(const matrix& A, const vector_t& b) noexcept 
# //     -> vector<physics::scalar_m, rows>
# //         requires (columns == rows) {

# //     std::array<vector_t, columns + 1> A_b = A.vstack(b); 
# //     std::array<physics::scalar_m, rows> result;

# //     for (size_t k{}; k < columns; ++k) {
        
# //         size_t pivot{k};
# //         value_t maxPivot;

# //         // Find the best pivot
# //         for (size_t i{k}; i < columns; ++i) 
# //             if (math::op::abs(A_b[k][i]) > maxPivot) {

# //                 maxPivot = math::op::abs(A_b[k][i]);
# //                 pivot = i;

# //             }

# //         // Swap rows k and p
# //         if (pivot != k)
# //             for (size_t i{k}; i < columns + 1; ++i)
# //                 std::swap(A_b[i][pivot], A_b[i][k]);

# //         // Elimination of variables
# //         for (size_t i{k + 1}; i < columns; ++i) {

# //             auto factor = A_b[k][i] / A_b[k][k];

# //             for (size_t j{k}; j < columns + 1; j++)
# //                 A_b[j][i] -= factor * A_b[j][k];

# //         }

# //     }

# //     // Back substitution
# //     for (long int k = columns - 1; k >= 0; k--) {

# //         value_t sum = A_b[columns][k];
# //         for (size_t j = k + 1; j < columns; j++)
# //             sum -= result[j] * A_b[j][k];

# //         result[k] = sum / A_b[k][k];

# //     }

# //     return result; 

# // }


proc `$`*[M, N: static[int], T](mat: Mat[M, N, T]): string =
    # Stringify Mat type
    for i in 0 ..< M:
        result.add("| ")
        for j in 0 ..< N:
            result.add($mat[i][j] & ' ')
        result.add("|\n")
