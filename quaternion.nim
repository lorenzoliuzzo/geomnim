import vector, matrix
import std/[math, fenv]

type 
    Quat*[V] = Vec4[V]

proc r*[V](q: Quat[V]): V {.inline} = q[0]
proc i*[V](q: Quat[V]): V {.inline} = q[1]
proc j*[V](q: Quat[V]): V {.inline} = q[2]
proc k*[V](q: Quat[V]): V {.inline} = q[3]

proc vec*[V](q: Quat[V]): Vec3[V] {.inline} = [q.i, q.j, q.k]

proc newQuat*[V](w: V, vec: Vec3[V]): Quat[V] {.inline} = [w].cat(vec)

proc conj*[V](q: Quat[V]): Quat[V] {.inline} = newQuat(q.scal, -q.vec)

proc inv*[V](q: Quat[V]): Quat[V] {.inline} = q.conj / q.norm

proc dot*[V](q1, q2: Quat[V]): Quat[V] {.inline} = 
    [
        q1.j * q2.k - q1.k * q2.j + q1.i * q2.r + q1.r * q2.i,
        q1.k * q2.i - q1.i * q2.k + q1.j * q2.r + q1.r * q2.j,
        q1.i * q2.j - q1.j * q2.i + q1.k * q2.r + q1.r * q2.k,
        q1.r * q2.r - q1.i * q2.i - q1.j * q2.j - q1.k * q2.k
    ]

proc rotate*[V](q: Quat[V], v: Vec3[V]): Vec3[V] {.inline} = dot(dot(q, newQuat(V(0), v), q.inv)).vec


proc angle*[V](q: Quat[V]): float {.inline} = 2.0 * arccos(q.r)

proc axis*(q: Quat): Vec3f =
  let sina =  sin(q.a / 2)
  [q.i / sina, q.j / sina, q.k / sina]

proc mat4*[V](q: Quat[V]): Mat4[V] =
    result[0][1] = -q.k
    result[0][2] = q.j
    result[1][2] = -q.i
    for j in 0 .. 2:
        result[j][3] = q[j + 1]
    result -= result.T
    for i in 0 .. 3:
        result[i][i] = q.r

proc mat3*[V](q: Quat[V]): Mat3[V] =
    let 
        sqx = q.i * q.i
        sqy = q.j * q.j
        sqz = q.k * q.k
        xy = q.i * q.j
        xz = q.i * q.k
        yz = q.j * q.k
        xw = q.i * q.r
        yw = q.j * q.r
        zw = q.k * q.r
    [
        [1 - 2 * sqy - 2 * sqz, 2 * xy - 2 * zw, 2 * xz + 2 * yw],
        [2 * xy + 2 * zw, 1 - 2 * sqx - 2 * sqz, 2 * yz - 2 * xw],
        [2 * xz - 2 * yw, 2 * yz + 2 * xw, 1 - 2 * sqx - 2 * sqy]
    ]

proc euler*[V](q: var Quat[V], ang: Vec3f) =
    let
        angles = ang / 2.0
        c1 = cos(angles[2])
        c2 = cos(angles[1])
        c3 = cos(angles[0])
        s1 = sin(angles[2])
        s2 = sin(angles[1])
        s3 = sin(angles[0])

    q[0] = c1 * c2 * s3 - s1 * s2 * c3
    q[1] = c1 * s2 * c3 + s1 * c2 * s3
    q[2] = s1 * c2 * c3 - c1 * s2 * s3
    q[3] = c1 * c2 * c3 + s1 * s2 * s3

proc euler*[V](q: Quat[V]): Vec3f = 
    let 
        sqw = q.r * q.r
        sqx = q.i * q.i
        sqy = q.j * q.j
        sqz = q.k * q.k
      
    result[1] = arcsin(2.0 * (q.r * q.j - q.i * q.k))
    if 0.5 * PI - abs(result[1]) > epsilon(float):
        result[2] = arctan2(2.0 * (q.i * q.j + q.r * q.k), sqx - sqy - sqz + sqw)
        result[0] = arctan2(2.0 * (q.r * q.i + q.j * q.k), sqw - sqx - sqy + sqz)
    else:
        result[2] = arctan2(2.0 * q.j * q.k - 2 * q.i * q.r, 2 * q.i * q.k + 2 * q.j * q.r)
        result[0] = 0.0

    if result[1] < V(0):
        result[2] = PI - result[2]


let q = newQuat(1.0, [2.0, 3.0, 4.0])
echo q
echo q.r
echo q.vec
echo q.mat4
echo q.mat3
echo q.euler
