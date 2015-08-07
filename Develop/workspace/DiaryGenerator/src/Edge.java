
public class Edge {
	Node n1;
	Node n2;
	
	public Edge(Node node1, Node node2)
	{
		n1 = node1;
		n2 = node2;
	}
	
	public Node getN1() { return n1; }
	
	public Node getN2() { return n2; }
	
	public String getN1Name() { return n1.getName(); }

	public String getN2Name() { return n2.getName(); }
}
