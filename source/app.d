import dsfml.window;
import dsfml.graphics;
import dsfml.system;
import std.conv;
import std.stdio;
import core.time;
import std.random;

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
		this.pos.x = x;
		this.pos.y = uniform(-1000, -500, rng);
		this.len.y = uniform(1, 25, rng);
		this.movespeed.y = map(this.len.y, 5, 25, 5, 15);
		this.len.x = this.len.y / 4;
		this.rect = new RectangleShape();
		this.rect.size(this.len);
		this.rect.fillColor = (Color(128, 0, 128));
		this.rect.position = this.pos;
	}

	void update()
	{
		this.pos.y += this.movespeed.y;
		if (this.pos.y > height)
			this.pos.y = -30.0;
		this.rect.position = this.pos;
	}

	void draw(RenderWindow window)
	{
		if (this.pos.y > -10 && this.pos.y < height + 10)
			window.draw(this.rect);
	}
}

void main()
{
	width = VideoMode.getDesktopMode().width;
	height = VideoMode.getDesktopMode().height;
	writeln("Width: " ~ to!string(width) ~ " Height: " ~ to!string(height));
	
	RenderWindow window = new RenderWindow(VideoMode(width, height), "Rain");
	window.setFramerateLimit(60);

	rng = Random(unpredictableSeed);

	Drop[] drops;
	foreach (i; 0 .. width / 10)
		drops ~= new Drop(i * 10);

	while (window.isOpen())
	{
		Event event;
		while (window.pollEvent(event))
			if (event.type == Event.EventType.Closed)
				window.close();

		window.clear(Color.White);
		foreach (drop; drops)
		{
			drop.draw(window);
			drop.update();
		}
		window.display();
	}
}
