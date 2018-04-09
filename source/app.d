import dsfml.window;
import dsfml.graphics;
import dsfml.system;

import std.conv : to;
import std.stdio : writeln;
import std.random : uniform, unpredictableSeed;

int width;
int height;

float map(float value, float istart, float istop, float ostart, float ostop)
{
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
}

Random rng;

class Drop
{
	Vector2f pos;
	Vector2f movespeed;
	Vector2f len;
	RectangleShape rect;
	
	this(int x)
	{
		//Set the position and normalize them by putting them above the screen
		this.pos.x = x;
		this.pos.y = uniform(-1000, -500, rng);
		
		//Set the length to a random number of pixels between 1 and 25
		this.len.y = uniform(1, 25, rng);
		this.len.x = this.len.y / 4;

		//Set the movespeed based on how long it is.
		//The smaller it is, the slower
		this.movespeed.y = map(this.len.y, 5, 25, 5, 15);
		
		//Create the screen rect to display
		this.rect = new RectangleShape();
		this.rect.size(this.len);
		this.rect.fillColor = (Color(128, 0, 128));
		this.rect.position = this.pos;
	}


	//Move this drop down by movespeed and set its position
	//If below the display, set it back to the beginning.
	void update()
	{
		this.pos.y += this.movespeed.y;
		if (this.pos.y > height)
			this.pos.y = -30.0;
		this.rect.position = this.pos;
	}

	//If on the display, draw it to the window
	void draw(RenderWindow window)
	{
		if (this.pos.y > -10 && this.pos.y < height + 10)
			window.draw(this.rect);
	}
}

void main()
{
	//Get the current window width and height
	width = VideoMode.getDesktopMode().width;
	height = VideoMode.getDesktopMode().height;
	writeln("Width: " ~ to!string(width) ~ " Height: " ~ to!string(height));
	
	//Create a new window and set the framerate to 60
	RenderWindow window = new RenderWindow(VideoMode(width, height), "Rain");
	window.setFramerateLimit(60);

	//Create a new random class
	rng = Random(unpredictableSeed);

	//Create all the drops 10 spaces apart
	Drop[] drops;
	foreach (i; 0 .. width / 10)
		drops ~= new Drop(i * 10);

	while (window.isOpen())
	{
		//Check if window is closed
		Event event;
		while (window.pollEvent(event))
			if (event.type == Event.EventType.Closed)
				window.close();

		//Clear the window with white
		window.clear(Color.White);

		//Update and draw all the drops
		foreach (drop; drops)
		{
			drop.draw(window);
			drop.update();
		}

		//Flip the display to show everything thats been drawn
		window.display();
	}
}
