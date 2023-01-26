/*******************************************************************************************
 * @Name         StarWarsCreateRecords
 * @Author       Adam Dalton
 * @Date         01/19/2023
 * @Group        Star Wars API Project
 * @Description  This class handles the record creation of the Star Wars planets, people and starships custom objects.
 *******************************************************************************************/
/* MODIFICATION LOG
 * Version          Developer          Date               Description
 *-------------------------------------------------------------------------------------------
 *  1.0              Adam      01/18/2023          Initial Creation
 *******************************************************************************************/
public with sharing class StarWarsCreateRecords {
  /**************************************************************************************
   * @Description  Method that creates a Star Wars Planet record based on the HTTP response from SWAPI
   * @Param		     GetPlanetsWrapperClass planet - wrapper class for the HHTP reponse for the planet API
   * @Return       Void
   * @Example
   **************************************************************************************/
  public static Star_Wars_Planet__c createPlanetRecord(
    PlanetWrapperv2.Results planet
  ) {
    Star_Wars_Planet__c newPlanet = new Star_Wars_Planet__c();
    //Creating new Salesforce record with the data populated
    newPlanet.Name = planet.name;
    newPlanet.Climate__c = planet.climate;
    newPlanet.Gravity__c = planet.gravity;
    newPlanet.Terrain__c = planet.terrain;
    newPlanet.URL__c = planet.url;

    String edited =
      planet.edited.substringBefore('T') +
      ' ' +
      planet.edited.substring(12, 19);
    newPlanet.API_Data_Updated__c = Datetime.valueOf(edited);
    System.debug(newPlanet.API_Data_Updated__c);

    String created =
      planet.created.substringBefore('T') +
      ' ' +
      planet.created.substring(12, 19);
    newPlanet.API_Data_Created__c = Datetime.valueOf(created);

    String rotationPeriod = planet.rotation_period;
    if (rotationPeriod.isNumeric() && rotationPeriod != null) {
      newPlanet.Rotation_period__c = Integer.valueOf(rotationPeriod);
    } else {
      newPlanet.Rotation_period__c = null;
    }

    String orbitalPeriod = planet.orbital_period;
    if (orbitalPeriod.isNumeric() && orbitalPeriod != null) {
      newPlanet.Orbital_Period__c = Integer.valueOf(orbitalPeriod);
    } else {
      newPlanet.Orbital_Period__c = null;
    }

    String diameter = planet.diameter;
    if (diameter.isNumeric() && diameter != null) {
      newPlanet.Diameter__c = Integer.valueOf(diameter);
    } else {
      newPlanet.Diameter__c = null;
    }

    String surfaceWater = planet.surface_water;
    if (surfaceWater.isNumeric() && surfaceWater != null) {
      newPlanet.Surface_Water__c = Integer.valueOf(surfaceWater);
    } else {
      newPlanet.Surface_Water__c = null;
    }

    String population = planet.population;
    if (population.isNumeric() && population != null) {
      newPlanet.Population__c = long.valueOf(population);
    } else {
      newPlanet.Population__c = null;
    }
    return newPlanet;
  }
  /**************************************************************************************
   * @Description  Method that creates a Star Wars Person record based on the HTTP response from SWAPI
   * @Param		     GetPeopleWrapperClass peopleResponse - wrapper class for the HHTP reponse for the person API
   * @Return       Void
   * @Example
   **************************************************************************************/
  public static Star_Wars_Person__c createPersonRecord(
    PeopleWrapperv2.Results peopleResponse
  ) {
    Star_Wars_Person__c newPerson = new Star_Wars_Person__c();
    newPerson.Name = peopleResponse.name;
    newPerson.Birth_Year__c = peopleResponse.birth_year;
    newPerson.Eye_Color__c = peopleResponse.eye_color;
    newPerson.Gender__c = peopleResponse.gender;
    newPerson.Hair_Color__c = peopleResponse.hair_color;
    newPerson.URL__c = peopleResponse.url;

    String mass = peopleResponse.mass;
    if (mass.isNumeric() && mass != null) {
      newPerson.Mass_kg__c = Integer.valueOf(mass);
    } else {
      newPerson.Mass_kg__c = 0;
    }

    String height = peopleResponse.height;
    if (height.isNumeric() && height != null) {
      newPerson.Height_cm__c = Integer.valueOf(height);
    } else {
      newPerson.Height_cm__c = null;
    }

    String edited =
      peopleResponse.edited.substringBefore('T') +
      ' ' +
      peopleResponse.edited.substring(12, 19);
    newPerson.API_Data_Updated__c = Datetime.valueOf(edited);

    String created =
      peopleResponse.created.substringBefore('T') +
      ' ' +
      peopleResponse.created.substring(12, 19);
    newPerson.API_Data_Created__c = Datetime.valueOf(created);

    return newPerson;
  }
   /**************************************************************************************
   * @Description  Method that creates a Star Wars Starship record based on the HTTP response from SWAPI
   * @Param		     GetStarshipWrapperClass starship - wrapper class for the HHTP reponse for the starship API
   * @Return       Void
   * @Example
   **************************************************************************************/
  public static Star_Wars_Starship__c createStarshipRecord(
    StarshipWrapperv2.Results starship
  ) {
    Star_Wars_Starship__c newStarship = new Star_Wars_Starship__c();
    newStarship.Name = starship.name;
    newStarship.Consumables__c = starship.consumables;
    newStarship.Manufacturer__c = starship.manufacturer;
    newStarship.Model__c = starship.model;
    newStarship.Starship_Class__c = starship.starship_class;
    newStarship.URL__c = starship.url;

    String cost = starship.cost_in_credits;
    if (cost.isNumeric() && cost != null) {
      newStarship.Cost_In_Credits__c = Long.valueOf(cost);
    } else {
      newStarship.Cost_In_Credits__c = null;
    }

    String cargo = starship.cargo_capacity;
    if (cargo.isNumeric() && cargo != null) {
      newStarship.Cargo_Capacity__c = Long.valueOf(cargo);
    } else {
      newStarship.Cargo_Capacity__c = null;
    }

    String crew = starship.crew;
    if (crew.isNumeric() && crew != null) {
      newStarship.Crew__c = Integer.valueOf(crew);
    } else {
      newStarship.Crew__c = null;
    }

    String hyperdrive = starship.hyperdrive_rating;
    if (hyperdrive.isNumeric() && hyperdrive != null) {
      newStarship.Hyperdrive_Rating__c = Double.valueOf(hyperdrive);
    } else {
      newStarship.Hyperdrive_Rating__c = null;
    }

    String mglt = starship.MGLT;
    if (mglt.isNumeric() && mglt != null) {
      newStarship.MGLT__c = Integer.valueOf(mglt);
    } else {
      newStarship.MGLT__c = null;
    }

    String length = starship.length;
    if (length.isNumeric() && length != null) {
      newStarship.Length__c = Double.valueOf(length);
    } else {
      newStarship.Length__c = null;
    }

    String passengers = starship.passengers;
    if (passengers.isNumeric() && passengers != null) {
      newStarship.Passengers__c = Integer.valueOf(passengers);
    } else {
      newStarship.Passengers__c = null;
    }

    String speed = starship.max_atmosphering_speed;
    if (speed.isNumeric() && speed != null) {
      newStarship.Max_Atmosphering_Speed__c = Integer.valueOf(speed);
    } else {
      newStarship.Max_Atmosphering_Speed__c = null;
    }

    String edited =
    starship.edited.substringBefore('T') +
      ' ' +
      starship.edited.substring(12, 19);
    newStarship.API_Data_Updated__c = Datetime.valueOf(edited);

    String created =
    starship.created.substringBefore('T') +
      ' ' +
      starship.created.substring(12, 19);
    newStarship.API_Data_Created__c = Datetime.valueOf(created);
    
    return newStarship;
  }
}
