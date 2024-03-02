import vector, matrix
import std/[math, fenv, unittest]

proc areClose[T](x, y: T): bool = abs(x - y) < epsilon(T)

proc areClose[N: static[int], T](x, y: Vec[N, T]): bool = 
    result = true
    for i in 0..<N: 
        if not areClose(x[i], y[i]):
            result = false
            break

proc areClose[M, N: static[int], T](x, y: Mat[M, N, T]): bool = 
    result = true
    for i in 0..<M: 
        for j in 0..<N:
            if not areClose(x[i][j], y[i][j]):
                result = false
                break

suite "Vec-UnitTest":    

    test "Init":
        let a = Vec[1, int]([1])
        discard a
        let b = Vec[2, int]([1, 1])
        let c = Vec[3, int]([1, 1, 1])
        let d = Vec[4, int]([1, 1, 1, 1])
        
        check(b == Vec2i([1, 1]))
        check(c == Vec3i([1, 1, 1]))
        check(d == Vec4i([1, 1, 1, 1]))

        let e = Vec[1, float]([1.0])
        discard e
        let f = Vec[2, float]([1.0, 1.0])
        let g = Vec[3, float]([1.0, 1.0, 1.0])
        let h = Vec[4, float]([1.0, 1.0, 1.0, 1.0])

        check(f == Vec2f([1.0, 1.0]))
        check(g == Vec3f([1.0, 1.0, 1.0]))
        check(h == Vec4f([1.0, 1.0, 1.0, 1.0]))


    test "Vec-Vec Op":
        let a = Vec2f([1.0, 0.0])
        let b = Vec2f([2.0, 1.0])
        check(a + b == Vec2f([3.0, 1.0]))
        check(a - b == Vec2f([-1.0, -1.0]))
        check(a * b == Vec2f([2.0, 0.0]))
        check(a / b == Vec2f([0.5, 0.0]))

        let c = Vec3f([0.0, 1.0, 0.0])
        let d = Vec3f([1.0, 2.0, 1.0])
        check(c + d == Vec3f([1.0, 3.0, 1.0]))
        check(c - d == Vec3f([-1.0, -1.0, -1.0])) 
        check(c * d == Vec3f([0.0, 2.0, 0.0])) 
        check(c / d == Vec3f([0.0, 0.5, 0.0])) 

        let e = Vec4f([1.0, 0.0, 1.0, 0.0])
        let f = Vec4f([1.0, 2.0, 2.0, 1.0])
        check(e + f == Vec4f([2.0, 2.0, 3.0, 1.0]))
        check(e - f == Vec4f([0.0, -2.0, -1.0, -1.0]))
        check(e * f == Vec4f([1.0, 0.0, 2.0, 0.0]))
        check(e / f == Vec4f([1.0, 0.0, 0.5, 0.0]))


    test "Vec-Num Op":
        let num = 2.0

        let a = Vec2f([1.0, 0.0])
        check(a + num == Vec2f([3.0, 2.0]))
        check(a - num == Vec2f([-1.0, -2.0]))
        check(a * num == Vec2f([2.0, 0.0]))
        check(a / num == Vec2f([0.5, 0.0]))

        let b = Vec3f([2.0, 1.0, 0.0])
        check(b + num == Vec3f([4.0, 3.0, 2.0]))
        check(b - num == Vec3f([0.0, -1.0, -2.0])) 
        check(b * num == Vec3f([4.0, 2.0, 0.0]))
        check(b / num == Vec3f([1.0, 0.5, 0.0])) 

        let c = Vec4f([1.0, 0.0, 1.0, 2.0])
        check(c + num == Vec4f([3.0, 2.0, 3.0, 4.0]))
        check(c - num == Vec4f([-1.0, -2.0, -1.0, 0.0]))
        check(c * num == Vec4f([2.0, 0.0, 2.0, 4.0]))
        check(c / num == Vec4f([0.5, 0.0, 0.5, 1.0]))


    test "Num-Vec Op":
        let num = 2.0

        let a = Vec2f([1.0, 2.0])
        check(num + a == Vec2f([3.0, 4.0]))
        check(num - a == Vec2f([1.0, 0.0]))
        check(num * a == Vec2f([2.0, 4.0]))
        check(num / a == Vec2f([2.0, 1.0]))

        let b = Vec3f([4.0, 1.0, 2.0])
        check(num + b == Vec3f([6.0, 3.0, 4.0]))
        check(num - b == Vec3f([-2.0, 1.0, 0.0])) 
        check(num * b == Vec3f([8.0, 2.0, 4.0]))
        check(num / b == Vec3f([0.5, 2.0, 1.0])) 

        let c = Vec4f([1.0, 2.0, 1.0, 2.0])
        check(num + c == Vec4f([3.0, 4.0, 3.0, 4.0]))
        check(num - c == Vec4f([1.0, 0.0, 1.0, 0.0]))
        check(num * c == Vec4f([2.0, 4.0, 2.0, 4.0]))
        check(num / c == Vec4f([2.0, 1.0, 2.0, 1.0]))


    test "Vec UnaryOp":
        let a = Vec2f([PI, PI / 2])
        check(-a == Vec2f([-PI, -PI / 2]))
        check(areClose(sin(a), Vec2f([0.0, 1.0])))
        check(areClose(cos(a), Vec2f([-1.0, 0.0])))


    test "Vec-Vec IncrOp":
        var a = Vec2f([1.0, 0.0])
        let b = Vec2f([2.0, 1.0])
        a += b 
        check(a == Vec2f([3.0, 1.0]))
        a -= b
        check(a == Vec2f([1.0, 0.0]))
        a *= b
        check(a == Vec2f([2.0, 0.0]))
        a /= b
        check(a == Vec2f([1.0, 0.0]))

        var c = Vec3f([0.0, 1.0, 2.0])
        let d = Vec3f([1.0, 1.0, 2.0])
        c += d
        check(c == Vec3f([1.0, 2.0, 4.0]))
        c -= d
        check(c == Vec3f([0.0, 1.0, 2.0]))
        c *= d
        check(c == Vec3f([0.0, 1.0, 4.0]))
        c /= d
        check(c == Vec3f([0.0, 1.0, 2.0])) 

        var e = Vec4f([1.0, 0.0, 1.0, 0.0])
        let f = Vec4f([1.0, 2.0, 2.0, 1.0])
        e += f
        check(e == Vec4f([2.0, 2.0, 3.0, 1.0]))
        e -= f
        check(e == Vec4f([1.0, 0.0, 1.0, 0.0]))
        e *= f
        check(e == Vec4f([1.0, 0.0, 2.0, 0.0]))
        e /= f
        check(e == Vec4f([1.0, 0.0, 1, 0.0]))


    test "Vec-Num IncrOp":
        let num = 2.0

        var a = Vec2f([1.0, 0.0])
        a += num
        check(a == Vec2f([3.0, 2.0]))
        a -= num
        check(a == Vec2f([1.0, 0.0]))
        a *= num
        check(a == Vec2f([2.0, 0.0]))
        a /= num 
        check(a == Vec2f([1.0, 0.0]))

        var b = Vec3f([0.0, 1.0, 0.0])
        b += num
        check(b == Vec3f([2.0, 3.0, 2.0]))
        b -= num
        check(b == Vec3f([0.0, 1.0, 0.0])) 
        b *= 2
        check(b == Vec3f([0.0, 2.0, 0.0])) 
        b /= 2
        check(b == Vec3f([0.0, 1.0, 0.0])) 

        var c = Vec4f([1.0, 0.0, 1.0, 0.0])
        c += num
        check(c == Vec4f([3.0, 2.0, 3.0, 2.0]))
        c -= num
        check(c == Vec4f([1.0, 0.0, 1.0, 0.0]))
        c *= num
        check(c == Vec4f([2.0, 0.0, 2.0, 0.0]))
        c /= num
        check(c == Vec4f([1.0, 0.0, 1.0, 0.0]))


    test "Vec-Vec BoolOp":
        let a: Vec2i = [1, 2]
        let b = [2, 4]
        check(b > a == Vec2[bool]([true, true]))
        check(2 * a == b)

    
    test "Vec.dot/cross":
        let a = Vec2f([1.0, 1.0])
        check(areClose(dot2(a, a), 2))
        check(areClose(a.norm, sqrt(2.0)))

        let b = Vec3f([1.0, 0.0, 0.0])
        let c = Vec3f([0.0, 1.0, 0.0])
        check(areClose(cross(b, c), Vec3f([0.0, 0.0, 1.0])))


    test "Vec.angle/dir":
        let a = Vec2f([1.0, 1.0])
        let b = Vec2f([0.0, 1.0])
        check(areClose(angle(a, b), PI / 4.0))
        check(areClose(dir(PI / 2.0), b))

        let c = Vec3f([0.0, 1.0, 0.0])
        check(areClose(dir(PI / 2.0, PI / 2.0), c))


suite "Mat-UnitTest":

    test "Mat.row/col":
        let I = Mat2i.id
        check(I.row(1) == [0, 1])
        check(I.col(0) == [1, 0])


    test "Mat.id":
        let I = Mat2f.id
        check(I == [[1.0, 0.0], [0.0, 1.0]])
        check(dot(I, I) == I)
        check(I.inv == I)
        check(I.T == I)
        check(I.det == 1)
        check(I.tr == 2)


    test "Mat.T":
        let vec2 = [1, 4]
        check(vec2.T == [[1], [4]])
        let mat2 = [[1, 2], [3, 4]]
        check(mat2.T == [[1, 3], [2, 4]])
        check(mat2.T.T == mat2)


    test "Mat.hstack/vstack":
        let mat2x3 = [[1.0, 2.0, 3.0], [0.0, 1.0, 4.0]]
        let mat3x3 = [[1.0, 2.0, 3.0], [0.0, 1.0, 4.0], [1.0, -2.0, 3.0]]
        let mat3x2 = [[1.0, 2.0], [0.0, 1.0]]

        check(mat2x3.vstack([1.0, 2.0, -3.0]) == [[1.0, 2.0, 3.0], [0.0, 1.0, 4.0], [1.0, 2.0, -3.0]])
        check(mat2x3.hstack([1.0, 2.0].T) == [[1.0, 2.0, 3.0, 1.0], [0.0, 1.0, 4.0, 2.0]])

        check(mat2x3.vstack(mat3x3) == [[1.0, 2.0, 3.0], [0.0, 1.0, 4.0], [1.0, 2.0, 3.0], [0.0, 1.0, 4.0], [1.0, -2.0, 3.0]])
        check(mat2x3.hstack(mat3x2) == [[1.0, 2.0, 3.0, 1.0, 2.0], [0.0, 1.0, 4.0, 0.0, 1.0]])


    test "Mat.minor":
        let mat3 = [[2, 0, 2], [2, 2, 2], [2, 2, 0]]
        check(mat3.minor(0, 0) == [[2, 2], [2, 0]])        
        check(mat3.minor(0, 1) == [[2, 2], [2, 0]])        
        check(mat3.minor(2, 2) == [[2, 0], [2, 2]])


    test "Mat.adj":
        let mat3 = [[-3, 2, -5], [-1, 0, -2], [3, -4, 1]]
        check(mat3.adj == [[-8, 18, -4], [-5, 12, -1], [4, -6, 2]])


    test "Mat.det":
        let mat2 = [[1, 2], [3, 4]]
        check(mat2.det == -2)
        let mat3 = [[1, -2, 3], [2, 0, 3], [1, 5, 4]]
        check(mat3.det == 25)
        let mat4 = [[1, 3, 1, 4], [3, 9, 5, 15], [0, 2, 1, 1], [0, 4, 2, 3]]
        check(mat4.det == -4)

        # ToDO: Check this error
        # let mat5 = [[0, 1, 0, -2, 1], [1, 0, 3, 1, 1], [1, -1, 1, 1, 1], [2, 2, 1, 0, 1], [3, 1, 1, 1, 2]]
        # check(mat5.det == -8)
        # let smat5 = [[5, 2, 1, 4, 6], [9, 4, 2, 5, 2], [11, 5, 7, 3, 9], [5, 6, 6, 7, 2], [7, 5, 9, 3, 3]]
        # check(smat5.det == -2003)


    test "Mat.inv":
        let mat2 = [[float 1, 2], [3, 4]]
        check(areClose(dot(mat2, mat2.inv), typeof(mat2).id))
        let mat3 = [[1.0, -2.0, 3.0], [2.0, 0.0, 3.0], [1.0, 5.0, 7.0]]
        check(areClose(dot(mat3, mat3.inv), typeof(mat3).id))
        let mat4 = [[float 1, 3, 1, 4], [3, 9, 5, 15], [0, 2, 1, 1], [0, 4, 2, 3]]
        check(areClose(dot(mat4, mat4.inv), typeof(mat4).id))
