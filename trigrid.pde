int kernel = 0; 
color[] choices = new color[3];
choices[0] = color(254, 0, 0); //red
choices[1] = color(0, 254, 0); //green
choices[2] = color(0, 0, 254); //blue

//useful globals for triangle vertexes computations
float root_of_three = 1.73205080757;
float long_side = root_of_three*(50.0/2.0);
float short_side = 25.0;

void setup() {  // this is run once.   
    
    // canvas size 
    size(200, 200);
    
    // set the background color
    background(255);
    
    // limit the number of frames per second
    //frameRate(30);
    
    // set the width of the line. 
    strokeWeight(1);
} 

void draw() {  // this is run repeatedly.  
        
    //points specified by (col, row) pairs
    int h = height / 50;
    int w = floor(width / long_side);

    float p1c, p1r, p2c, p2r, p3c, p3r;
    p1c = 0.0;
    p1r = 0.0;
    p2c = long_side; 
    p2r = short_side;
    p3c = 0.0;
    p3r = 50.0;

    stroke(200, 50); //light, translucent gray
    for (int j = 0; j < w; j++) { 

        //draw column of right facing triangles            
        for (int i = 0; i < h; i++) {
        
            triangle(p1c, p1r, p2c, p2r, p3c, p3r);
            
            //shift all vertexes downwards 
            p1r += 50;
            p2r += 50;
            p3r += 50;
        }
        
        //shift the triangle column to the right    
            p1c += long_side; 
            p2c += long_side;
            p3c += long_side;
            
        //prepare row seeds based on column parity
        if (j % 2 != 0) {
            p1r = 0.0;
            p2r = short_side;
            p3r = 50.0;

        } else {
            p1r = short_side;
            p2r = 2.0*short_side;
            p3r = 50.0 + short_side;
            
            //compensate for top missing lines
            //line(col, row, col, row);
            line(p1c, p1r, p2c, 0.0);
            line(p1c, p1r, p1c, 0.0);
        }
    } 

    //grid is done setting up 
    noLoop();

}

void mouseClicked() {

    //mouseX is col, mouseY is row
    color sample = get(mouseX, mouseY);
    
    //color transitions
    //if (red(sample) == 255)) {
    if ((sample >> 16 & 0xFF) == 255)
    {
        fill(254,0,0);
        stroke(254,0,0);
    }
    //else if (red(sample) == 254)) {
    else if ((sample >> 16 & 0xFF)  == 254) 
    {
        fill(0, 254,0);
        stroke(0,254,0);
    }
    //else if (green(sample) == 254)) {
    else if ((sample >> 8 & 0xFF)  == 254) 
    {
        fill(0, 0, 254);
        stroke(0,0,254);
    }
    //else if (blue(sample) == 254)) {
    else if ((sample & 0xFF)  == 254) 
    {
        fill(255,255,255);
        stroke(255,255,255);
    }  
    
    //fill in proper triangle
    float left_col, bottom_row;
    
    //mouseX is col, mouseY is row
    left_col = floor(mouseX / long_side)*long_side;
    
 if ((floor(mouseX / long_side) % 2) != 0) { 
        //odd column orientation
        findType(mouseX, mouseY, left_col, true);
    } else 
    {
        findType(mouseX, mouseY, left_col, false);
    }
}

void findType(float mouseX, float mouseY, float left_col, boolean odd) {
    String type = "";

    if (mouseY % 25 == 0) { //on a categorical border
        if ((mouseY / 25) % 2 == 0) {
             if(odd) { type = "left"; }
             else {type = "right"}
        } 
        else {
            if (odd) { type = "right"; }
            else {type = "left";}
        }
    }  
    
    else {
       float col = mouseX - left_col;
       float y = 25.0 - (mouseY % 25.0);

       if (floor(mouseY / 25.0) % 2 == 0) {
            if (odd) { //type 1 case
                float y_comp = col / root_of_three;
                if (y > y_comp) { type = "right"; }
                else { type = "left"; }
            } 
            else { //type 2 case
                float y_comp = 1.0 - (col / root_of_three);
                if (y > y_comp) { type = "left"; }
                else { type = "right"; }
            }
       } 
       else {
            if (odd) { //type 2 case
                float y_comp = 1.0 - (col / root_of_three);
                if (y > y_comp) { type = "left"; }
                else { type = "right"; }
            } 
            else { //type 1 case
                float y_comp = col / root_of_three;
                if (y > y_comp) { type = "right"; }
                else { type = "left"; }
            }        

       }
    }

 makeTriangle(type, odd, left_col);
}

void makeTriangle(String type, boolean odd, float left_col) {
    if (type.equals("")) {//user clicked on a border do nothing
    }
    else if (odd) {
        if (type.equals("left")) {
        //top -right corner
        float top_right_row = floor(mouseY / 50.0)*50.0;
        
        //triangle(c, r, c, r, c, r);
        triangle(left_col, top_right_row + 25.0, left_col + long_side, top_right_row, left_col + long_side, top_right_row + 50.0);
        
        } else {
        //top -left corner
        float top_left_row = floor((mouseY - 25.0) / 50.0)*50.0 + 25.0;
        
        //triangle(c, r, c, r, c, r);
        triangle(left_col, top_left_row, left_col + long_side, top_left_row + 25.0, left_col, top_left_row + 50.0);
        }

    } 
    else {
        if (type.equals("left")) {
        //top -right corner
        float top_right_row = floor((mouseY - 25.0)/ 50.0)*50.0 + 25.0;
        
        //triangle(c, r, c, r, c, r);
        triangle(left_col, top_right_row + 25.0, left_col + long_side, top_right_row, left_col + long_side, top_right_row + 50.0);
        
        } else {
        //top -left corner
        float top_left_row = floor(mouseY / 50.0)*50.0;
        
        //triangle(c, r, c, r, c, r);
        triangle(left_col, top_left_row, left_col + long_side, top_left_row + 25.0, left_col, top_left_row + 50.0);
        }
    }

}
