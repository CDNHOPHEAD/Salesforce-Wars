public with sharing class PeopleWrapperv2 {
    public Integer count;
	public String next;
	public String previous;
	public List<Results> results;
    
    public class Results {
        public String name;	
        public String birth_year;	
        public String eye_color;
        public String gender;	
        public String hair_color;	
        public String height;	
        public String mass;		
        public String url;
        public String homeworld;
        public String created;
        public String edited;
        public List<String> starships;	
}
}