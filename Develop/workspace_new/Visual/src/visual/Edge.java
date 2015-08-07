package visual;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Point;

/**
 * ***********************************************
 * Class Edge
 * ***********************************************
 * Description: A pair of two nodes.
 * Constructors:
 * Edge(Node n1, Node n2)
 * 
 * Methods:
 * getV1(): returns name of Node n1 as String
 * getV2(): returns name of Node n2 as String
 * drawArrow(Graphics g, int x0, int y0, int x1, int y1, int headLength, int headAngle): determines the final angles 
 * 	necessary to draw the line properly between two points
 * draw(Graphics g): draws the arrow connecting two nodes. Does some logic to determine arrows end point.
 * 
 */
public class Edge
{
	private Node n1;
	private Node n2;

	public Edge(Node n1, Node n2)
	{
		this.n1 = n1;
		this.n2 = n2;
	}

	public void draw(Graphics g) {
		Point p1 = n1.getLocation();
		Point p2 = n2.getLocation();
		g.setColor(Color.RED);
		int arrowX;
		int arrowY;
		if (n1.isSelected())
		{
			if (p1.x > p2.x + 50 + Node.getR())
			{
				arrowX = p2.x + Node.getR();
			}
			else if (p1.x < p2.x + Node.getR() + 50 && p1.x > p2.x - Node.getR() - 50)
			{
				arrowX = p2.x;
			}
			else
			{
				arrowX = p2.x - Node.getR();
			}
			if (p1.y > p2.y + 50 + Node.getR())
			{
				arrowY = p2.y + Node.getR();
			}
			else if (p1.y < p2.y + Node.getR() + 50 && p1.y > p2.y - Node.getR() - 50)
			{
				arrowY = p2.y;
			}
			else
			{
				arrowY = p2.y - Node.getR();
			}
			drawArrow(g, p1.x, p1.y, arrowX, arrowY, 15, 15);
		}
	}
	
	/**
	 * Draw an arrow connecting two points
	 */
	static public void drawArrow(Graphics g, int x0, int y0, int x1, int y1, int headLength, int headAngle) {
		double offs = headAngle * Math.PI / 180.0;
		double angle = Math.atan2(y0 - y1, x0 - x1);
		int[] xs = { x1 + (int) (headLength * Math.cos(angle + offs)), x1, x1 + (int) (headLength * Math.cos(angle - offs)) };
		int[] ys = { y1 + (int) (headLength * Math.sin(angle + offs)), y1, y1 + (int) (headLength * Math.sin(angle - offs)) };
		g.drawLine(x0, y0, x1, y1);
		g.drawPolyline(xs, ys, 3);
	}

	public Node getN1(){
		return n1;
	}
	
	public Node getN2(){
		return n2;
	}
	
	public String getV1() {
		return n1.getName();
	}

	public String getV2() {
		return n2.getName();
	}
}