//Kinect Based Natural Interface for Puppet Control
//Azharuddin
//Deepak
//Dewakar
//Giridharan
//Jagan

import SimpleOpenNI.*;
import processing.serial.*;
SimpleOpenNI  context;
Serial myPort;
color[]       userClr = new color[]{ 
                                     color(255,0,0),
                                     color(110,155,110),
                                     color(100,100,055),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
PVector com = new PVector();                                   
PVector com2d = new PVector();                                   

void setup()
{
  size(640,480);
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't begin SimpleOpenNI,the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser();
 
  background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  smooth();  
}

void draw()
{
   // update the cam
  context.update();
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  image(context.userImage(),0,0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      updateAngles(); 
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    }      
      
    // draw the center of mass
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);
      stroke(100,255,0);
      strokeWeight(1);
      beginShape(LINES);
        vertex(com2d.x,com2d.y - 5);
        vertex(com2d.x,com2d.y + 5);

        vertex(com2d.x - 5,com2d.y);
        vertex(com2d.x + 5,com2d.y);
      endShape();
      
      fill(0,255,100);
      text(Integer.toString(userList[i]),com2d.x,com2d.y);
    }
  }    
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
}  

//Left Arm
PVector lHand = new PVector();
PVector lElbow = new PVector();
PVector lShoulder = new PVector();
//Left leg
PVector lFoot = new PVector();
PVector lKnee = new PVector();
PVector lHip = new PVector();
//Right arm
PVector rHand = new PVector();
PVector rElbow = new PVector();
PVector rShoulder = new PVector();
//Right Leg
PVector rFoot = new PVector();
PVector rKnee = new PVector();
PVector rHip = new PVector();

float[] angles = new float[9];

float angle(PVector a, PVector b, PVector c) 
{
float angle01 = atan2(a.y - b.y, a.x - b.x);
float angle02 = atan2(b.y - c.y, b.x - c.x);
float ang = angle02 - angle01;
return ang;
}

void updateAngles()
{
// Left Arm
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HAND, lHand);
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_ELBOW, lElbow);
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_SHOULDER, lShoulder);
// Left Leg
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_FOOT, lFoot);
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_KNEE, lKnee);
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HIP, lHip);
// Right Arm
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HAND, rHand);
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_ELBOW, rElbow);
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rShoulder);
// Right Leg
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_FOOT, rFoot);
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_KNEE, rKnee);
context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HIP, rHip);
convert();
}
void convert()
{
//Real World conversion of angles
//Left hand
context.convertRealWorldToProjective(lHand, lHand);
context.convertRealWorldToProjective(lElbow, lElbow);
context.convertRealWorldToProjective(lShoulder, lShoulder);
//Left leg
context.convertRealWorldToProjective(lFoot, lFoot);
context.convertRealWorldToProjective(lKnee, lKnee);
context.convertRealWorldToProjective(lHip, lHip);
//Right arm
context.convertRealWorldToProjective(rHand, rHand);
context.convertRealWorldToProjective(rElbow, rElbow);
context.convertRealWorldToProjective(rShoulder, rShoulder);
//Right Leg
context.convertRealWorldToProjective(rFoot, rFoot);
context.convertRealWorldToProjective(rKnee, rKnee);
context.convertRealWorldToProjective(rHip, rHip);
// Left-Side Angles
angles[1] = angle(lShoulder, lElbow, lHand);
angles[2] = angle(rShoulder, lShoulder, lElbow);
angles[3] = angle(lHip, lKnee, lFoot);
angles[4] = angle(new PVector(lHip.x, 0), lHip, lKnee);
// Right-Side Angles
angles[5] = angle(rHand, rElbow, rShoulder);
angles[6] = angle(rElbow, rShoulder, lShoulder );
angles[7] = angle(rFoot, rKnee, rHip);
angles[8] = angle(rKnee, rHip, new PVector(rHip.x, 0));

int a1,a2,a4,a5,a6,a8;
int t1,t2,t4,t5,t6,t8;

a1=abs(int(angles[1]*57.29));
a2=abs(int(angles[2]*57.29));
a4=abs(int(angles[4]*57.29));
a5=abs(int(angles[5]*57.29));
a6=abs(int(angles[6]*57.29));
a8=abs(int(angles[8]*57.29));

println(a1);
println(a2);
println(a4);
println(a5);
println(a6);
println(a8);

                t1=a1/10;
                t2=a2/10;
                t4=a4/10;
                t5=a5/10;
                t6=a6/10;
                t8=a8/10;
                t1=t1+48;
                t2=t2+48;
                t4=t4+48;
                t5=t5+48;
                t6=t6+48;
                t8=t8+48;
                //println(t1-48);
                //println(t2-48);
    //println(c);
    //println(d);
   // myPort.write(t1);
    myPort.write(t2);
    myPort.write(t4);
    //myPort.write(t5);
    myPort.write(t6);;
    myPort.write(t8);

}
