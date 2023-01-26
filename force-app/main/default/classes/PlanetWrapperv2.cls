public with sharing class PlanetWrapperv2 {
    public Integer count;
	public String next;
	public String previous;
	public List<Results> results;
    
    public class Results {
    public String name;	
	public String rotation_period;	
	public String orbital_period;	
	public String diameter;	
	public String climate;	
	public String gravity;	
	public String terrain;	
	public String surface_water;	
	public String population;
	public String url;		
	public List<String> residents;
	public String created;
	public String edited;
    }
}