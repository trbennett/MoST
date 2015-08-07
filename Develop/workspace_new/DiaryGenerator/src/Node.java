
// A node in our hypergraph (really, potentially two nodes. 
//One that represents this node as a receiver for incoming edge to startingPosture node group, and one that represents this node
//as a 'sender' for an outgoing edge to the endingPosture node group
public class Node {

	boolean hasDuration;
	boolean isTransitional;
	String startingPosture;
	String endingPosture;
	String name;
	
	public Node(String mvmtName, String startPosture, String endPosture, boolean durational, boolean transitional)
	{
		name = mvmtName;
		startingPosture = startPosture;
		endingPosture = endPosture;
		hasDuration = durational;
		isTransitional = transitional;
	}
	
	public String getName() { return name; }
	public String getStartPosture() { return startingPosture; }
	public String getEndPosture() { return endingPosture; }
	public boolean isDurational() { return hasDuration; }
	public boolean isTransitional() { return isTransitional; }
}
