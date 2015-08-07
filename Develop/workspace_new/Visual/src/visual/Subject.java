package visual;

public class Subject {
	int subjNum;			// The actual subject number, m0001_sXX_m01_n01.txt
	String subjTitle;		// The subject title, MX
	
	public int getSubjNum(){ return subjNum; }
	public String getSubjTitle(){ return subjTitle; }
	public void setSubjNum(int number){ subjNum = number; }
	public void setSubjTitle(String title) { subjTitle = title;}
}
