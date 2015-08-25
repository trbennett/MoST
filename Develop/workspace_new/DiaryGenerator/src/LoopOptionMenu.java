import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;

import javax.swing.BorderFactory;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;

@SuppressWarnings("serial")
public class LoopOptionMenu extends JPanel {
	
	JSpinner iterationSpinner;
	
	public LoopOptionMenu() 
	{
	      setLayout(new GridBagLayout());
	      setBorder(BorderFactory.createCompoundBorder(
	            BorderFactory.createTitledBorder("Options"),
	            BorderFactory.createEmptyBorder(5, 5, 5, 5)));
	      GridBagConstraints gbc;
          gbc = createGbc(0, 0);
          add(new JLabel("Iterations:", JLabel.LEFT), gbc);
          gbc = createGbc(1, 0);
          SpinnerNumberModel iterModel = new SpinnerNumberModel(1, 0, 120, 1);
          iterationSpinner = new JSpinner(iterModel);
          add(iterationSpinner);
	}
	
	public int getNumIterations() 
	{
		return (int)iterationSpinner.getValue();
	}
	
	private static final Insets WEST_INSETS = new Insets(5, 0, 5, 5);
	private static final Insets EAST_INSETS = new Insets(5, 5, 5, 0);
	
	 private GridBagConstraints createGbc(int x, int y) {
	      GridBagConstraints gbc = new GridBagConstraints();
	      gbc.gridx = x;
	      gbc.gridy = y;
	      gbc.gridwidth = 1;
	      gbc.gridheight = 1;

	      gbc.anchor = (x == 0) ? GridBagConstraints.WEST : GridBagConstraints.EAST;
	      gbc.fill = (x == 0) ? GridBagConstraints.BOTH
	            : GridBagConstraints.HORIZONTAL;

	      gbc.insets = (x == 0) ? WEST_INSETS : EAST_INSETS;
	      gbc.weightx = (x == 0) ? 0.1 : 1.0;
	      gbc.weighty = 1.0;
	      return gbc;
	   }
}
