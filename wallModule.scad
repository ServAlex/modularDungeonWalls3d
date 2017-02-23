wallWidth = 14;
wallHeight = 3;
reinforcedWallHeight = 3;

jointHeight = 2;
jointHeightTolerance = 0.5;
jointMinWidth = 0.27;
jointMaxWidth = 0.44;
jointLength = 0.21;

tolerance = 0.3;

config = "mffft";

$fn = 100;

module jointTemplate(expansion = 0, jointHeightOffset = 0)
{
	minkowski()
	{
		linear_extrude(height = jointHeight - jointHeightOffset){
			polygon(points=[[0, wallWidth*jointMinWidth/2], 
							[-jointLength*wallWidth, wallWidth*jointMaxWidth/2], 
							[-jointLength*wallWidth, -wallWidth*jointMaxWidth/2], 
							[0, -wallWidth*jointMinWidth/2]], 
					paths=[[0,1,2,3]]);
		}
		difference()
		{
			cylinder(r=expansion, h = 0.0000000001);
			translate([0, -50, -20])
			cube([100,100,100]);
		}
	}
}

module mJoint()
{
	translate([wallWidth, wallWidth/2, 0])
	jointTemplate(0, jointHeightTolerance); 

	translate([wallWidth-jointLength*wallWidth-2, wallWidth/2 - jointMaxWidth*wallWidth/2, jointHeight-jointHeightTolerance])
	cube([2.8, jointMaxWidth*wallWidth, reinforcedWallHeight - (jointHeight-jointHeightTolerance)]);
}

module emptyWall()
{
	hull()
	{
//reinforcedWallHeight
		cube([wallWidth, wallWidth, jointHeight]);
		diff = reinforcedWallHeight-jointHeight;

		translate([diff,diff,jointHeight])
		cube([wallWidth-2*diff, wallWidth-2*diff, diff]);
	}
}

module fJoint(terminal = false)
{
	difference()
	{
		hull()
		{
//reinforcedWallHeight
			cube([wallWidth, wallWidth, jointHeight]);
			diff = reinforcedWallHeight-jointHeight;

			translate([diff,diff,jointHeight])
			cube([wallWidth-2*diff, wallWidth-2*diff, diff]);
		}

		translate([wallWidth/2, -0.0001, -0.0001])
		rotate([0, 0, -90])
		jointTemplate(tolerance);

		translate([wallWidth/2, wallWidth+0.0001, -0.0001])
		rotate([0, 0, 90])
		jointTemplate(tolerance);

		if(terminal)
		{
			translate([wallWidth+0.0001, wallWidth/2, -0.0001])
			jointTemplate(tolerance);
		}
	}
}

translate([0,0,reinforcedWallHeight])
rotate([180, 0, 0])
for(i=[0:len(config)])
{
	echo(config[i]);
	translate([wallWidth*i, 0, 0])
			if(config[i]=="m") mJoint();
	else 	if(config[i]=="e") emptyWall();
	else 	if(config[i]=="f") fJoint();
	else 	if(config[i]=="t") fJoint(terminal=true);
}
