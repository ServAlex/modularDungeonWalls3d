d = 13.5;
h = 3;
clibD = 1;

$fn = 30;

module clipHalf()
{
	translate([0,1.0+0.3+0.5,0])
	minkowski()
	{
		union()
		{
			translate([-2.5, 0, 0])
			cube([5,0.1,4]);

			translate([-2.5, 0.0, 4.0])
			rotate([10, 0, 0])
			cube([5,0.1,2]);
		}
		
		sphere(1.0);
	}
}

rotate([0,0,180])
clipHalf();

clipHalf();


translate([0, 0, -h])
minkowski()
{
	cylinder(h = h-1, r = d/2-0.5, $fn=100);
	difference()
	{
		sphere(1, center = true);
		translate([0,0,-50])
		cube([100,100,100], center=true);
	}
}
