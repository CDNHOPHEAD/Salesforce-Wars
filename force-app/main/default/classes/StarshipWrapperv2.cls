public with sharing class StarshipWrapperv2 {
	public Integer count;
	public String next;
	public String previous;
	public List<Results> results;

	public class Results {
		public String name;
		public String model;
		public String manufacturer;
		public String cost_in_credits;
		public String length;
		public String max_atmosphering_speed;
		public String crew;
		public String passengers;
		public String cargo_capacity;
		public String consumables;
		public String hyperdrive_rating;
		public String MGLT;
		public String starship_class;
		public List<String> pilots;
		public List<String> films;
		public String created;
		public String edited;
		public String url;
	}
	public class Pilots {
	}
}