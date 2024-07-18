using System;
namespace bge_core;

struct Vector2
{
	double x;
	double y;

	public this (double x, double y)
	{
		this.x = x;
		this.y = y;
	}

	public static Vector2 operator+(Vector2 lhs, Vector2 rhs)
	{
	    return .(lhs.x + rhs.x, lhs.y + rhs.y);
	}

	public static Vector2 operator-(Vector2 lhs, Vector2 rhs)
	{
	    return .(lhs.x - rhs.x, lhs.y - rhs.y);
	}

	public static Vector2 operator++(Vector2 val)
	{
	    return .(val.x + 1, val.y + 1);
	}

	public static Vector2 operator--(Vector2 val) 
	{
	    return .(val.x - 1, val.y - 1);
	}

	public void operator+=(Vector2 rhs) mut
	{
	    x += rhs.x;
	    y += rhs.y;
	}

	public static int operator<=>(Vector2 lhs, Vector2 rhs)
	{
	    int cmp = lhs.x <=> rhs.x;
	    if (cmp != 0)
	        return cmp;
	    return lhs.y <=> rhs.y;
	}

	public static operator Vector2(double[2] val)
	{
	    return .(val[0], val[1]);
	}

	[Test]
	public static void TestVector2()
	{
		Test.Assert((Vector2(1, 1) + Vector2(1, 1)) == Vector2(2, 2));
		Test.Assert((Vector2(1, 1) - Vector2(1, 1)) == Vector2(0, 0));
		Test.Assert((Vector2(1, 1)++) == Vector2(1, 1));
		Test.Assert((Vector2(1, 1)--) == Vector2(1, 1));
		Test.Assert(++(Vector2(1, 1)) == Vector2(2, 2));
		Test.Assert(--(Vector2(1, 1)) == Vector2(0, 0));
	}
}


struct Vector3
{
	double x;
	double y;
	double z;

	public this (double x, double y, double z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public static Vector3 operator+(Vector3 lhs, Vector3 rhs)
	{
	    return .(lhs.x + rhs.x, lhs.y + rhs.y, lhs.x + rhs.z);
	}

	public static Vector3 operator-(Vector3 lhs, Vector3 rhs)
	{
	    return .(lhs.x - rhs.x, lhs.y - rhs.y, lhs.x - rhs.z);
	}

	public static Vector3 operator++(Vector3 val)
	{
	    return .(val.x + 1, val.y + 1, val.z +1);
	}

	public static Vector3 operator--(Vector3 val) 
	{
	    return .(val.x - 1, val.y - 1, val.z - 1);
	}

	public void operator+=(Vector3 rhs) mut
	{
	    x += rhs.x;
	    y += rhs.y;
		z += rhs.z;
	}

	public static int operator<=>(Vector3 lhs, Vector3 rhs)
	{
	    int cmp = lhs.x <=> rhs.x;
	    if (cmp != 0)
	        return cmp;
		cmp = lhs.y <=> rhs.y;
		if(cmp != 0)
			return cmp;
	    return lhs.z <=> rhs.z;
	}

	public static operator Vector3(double[3] val)
	{
	    return .(val[0], val[1], val[2]);
	}
}