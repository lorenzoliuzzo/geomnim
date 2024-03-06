import std/unittest
import geomnim/vector
import std/math
import geomnim/common

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


    test "Vec-Vec BoolOp":
        let a: Vec2i = [1, 2]
        let b = [2, 4]
        check(b > a == Vec2[bool]([true, true]))
        check(2 * a == b)