import java.util.ArrayList;

public class HTMLElement {
	public String name;
	public ArrayList<HTMLElement> childElements;
	public String text;
	
	public HTMLElement (String text) {
		this.text = text;
	}
	
	public HTMLElement (ArrayList<HTMLElement> childElements) {
		this.childElements = childElements;
	}

}
