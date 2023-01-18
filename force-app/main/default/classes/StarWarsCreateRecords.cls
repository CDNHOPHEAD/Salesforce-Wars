/*******************************************************************************************
 * @Name         GetPeopleAPICallout
 * @Author       Adam Dalton
 * @Date         01/11/2023
 * @Group        Star Wars API Project
 * @Description  This class contains the HTTP 'GET' request that will grab the person data from swapi.dev/api and populate the Star_Wars_Person__c custom object in the Salesforce Org
 *******************************************************************************************/
/* MODIFICATION LOG
 * Version          Developer          Date               Description
 *-------------------------------------------------------------------------------------------
 *  1.0              Adam      01/09/2023          Initial Creation
 *  2.0              Adam      01/12/2023         Created a for loop so that the method iterates through all the endpoints in the API and create a new record
 *******************************************************************************************/
public with sharing class StarWarsCreateRecords {
  /**************************************************************************************
   * @Description  Future method to get Star Wars "Person" data from Open API and then insert a new Star_Wars_Person__c record with the related data
   * @Param		N/A
   * @Return       Void
   * @Example
   **************************************************************************************/
  public static Star_Wars_Planet__c createPlanetRecord(
    GetPlanetsWrapperClass planetResponse
  ) {
    Star_Wars_Planet__c newPlanet = new Star_Wars_Planet__c();
    //Creating new Salesforce record with the data populated
    newPlanet.Name = planetResponse.name;
    newPlanet.Climate__c = planetResponse.climate;
    newPlanet.Gravity__c = planetResponse.gravity;
    newPlanet.Terrain__c = planetResponse.terrain;
    newPlanet.URL__c = planetResponse.url;

    String edited =
      planetResponse.edited.substringBefore('T') +
      ' ' +
      planetResponse.edited.substring(12, 19);
    newPlanet.API_Data_Updated__c = Datetime.valueOf(edited);
    System.debug(newPlanet.API_Data_Updated__c);

    String created =
      planetResponse.created.substringBefore('T') +
      ' ' +
      planetResponse.created.substring(12, 19);
    newPlanet.API_Data_Created__c = Datetime.valueOf(created);

    String rotationPeriod = planetResponse.rotation_period;
    if (rotationPeriod.isNumeric() && rotationPeriod != null) {
      newPlanet.Rotation_period__c = Integer.valueOf(rotationPeriod);
    } else {
      newPlanet.Rotation_period__c = null;
    }

    String orbitalPeriod = planetResponse.orbital_period;
    if (orbitalPeriod.isNumeric() && orbitalPeriod != null) {
      newPlanet.Orbital_Period__c = Integer.valueOf(orbitalPeriod);
    } else {
      newPlanet.Orbital_Period__c = null;
    }

    String diameter = planetResponse.diameter;
    if (diameter.isNumeric() && diameter != null) {
      newPlanet.Diameter__c = Integer.valueOf(diameter);
    } else {
      newPlanet.Diameter__c = null;
    }

    String surfaceWater = planetResponse.surface_water;
    if (surfaceWater.isNumeric() && surfaceWater != null) {
      newPlanet.Surface_Water__c = Integer.valueOf(surfaceWater);
    } else {
      newPlanet.Surface_Water__c = null;
    }

    String population = planetResponse.population;
    if (population.isNumeric() && population != null) {
      newPlanet.Population__c = long.valueOf(population);
    } else {
      newPlanet.Population__c = null;
    }
    return newPlanet;
  }
  //*************************************************************************************************** */
  public static Star_Wars_Person__c createPersonRecord(
    GetPeopleWrapperClass peopleResponse
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
  //*************************************************************************************************** */
  public static Star_Wars_Starship__c createStarshipRecord(
    GetStarshipWrapperClass starshipResponse
  ) {
    Star_Wars_Starship__c newStarship = new Star_Wars_Starship__c();
    newStarship.Name = starshipResponse.name;
    newStarship.Consumables__c = starshipResponse.consumables;
    newStarship.Manufacturer__c = starshipResponse.manufacturer;
    newStarship.Model__c = starshipResponse.model;
    newStarship.Starship_Class__c = starshipResponse.starship_class;
    newStarship.URL__c = starshipResponse.url;

    String cost = starshipResponse.cost_in_credits;
    if (cost.isNumeric() && cost != null) {
      newStarship.Cost_In_Credits__c = Long.valueOf(cost);
    } else {
      newStarship.Cost_In_Credits__c = null;
    }

    String cargo = starshipResponse.cargo_capacity;
    if (cargo.isNumeric() && cargo != null) {
      newStarship.Cargo_Capacity__c = Long.valueOf(cargo);
    } else {
      newStarship.Cargo_Capacity__c = null;
    }

    String crew = starshipResponse.crew;
    if (crew.isNumeric() && crew != null) {
      newStarship.Crew__c = Integer.valueOf(crew);
    } else {
      newStarship.Crew__c = null;
    }

    String hyperdrive = starshipResponse.hyperdrive_rating;
    if (hyperdrive.isNumeric() && hyperdrive != null) {
      newStarship.Hyperdrive_Rating__c = Double.valueOf(hyperdrive);
    } else {
      newStarship.Hyperdrive_Rating__c = null;
    }

    String mglt = starshipResponse.MGLT;
    if (mglt.isNumeric() && mglt != null) {
      newStarship.MGLT__c = Integer.valueOf(mglt);
    } else {
      newStarship.MGLT__c = null;
    }

    String length = starshipResponse.length;
    if (length.isNumeric() && length != null) {
      newStarship.Length__c = Double.valueOf(length);
    } else {
      newStarship.Length__c = null;
    }

    String passengers = starshipResponse.passengers;
    if (passengers.isNumeric() && passengers != null) {
      newStarship.Passengers__c = Integer.valueOf(passengers);
    } else {
      newStarship.Passengers__c = null;
    }

    String speed = starshipResponse.max_atmosphering_speed;
    if (speed.isNumeric() && speed != null) {
      newStarship.Max_Atmosphering_Speed__c = Integer.valueOf(speed);
    } else {
      newStarship.Max_Atmosphering_Speed__c = null;
    }

    String edited =
      starshipResponse.edited.substringBefore('T') +
      ' ' +
      starshipResponse.edited.substring(12, 19);
    newStarship.API_Data_Updated__c = Datetime.valueOf(edited);

    String created =
      starshipResponse.created.substringBefore('T') +
      ' ' +
      starshipResponse.created.substring(12, 19);
    newStarship.API_Data_Created__c = Datetime.valueOf(created);
    
    return newStarship;
  }
}
