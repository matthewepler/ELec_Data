/* 
 Election Data 
 A series of tutorials for importing table data 
 and making basic interactive visuals
 
 Focus is comparing voter figures for all candidates of one election
 User chooses topic
 The values for that election appear in a ring
 The values for the topic over time appear below as a graph with a marker for current year
 User can slide along the graph to change which year is shown above as a ring.
 
 Matthew Epler 2012
 for School of Data
 */

String filename = "US_Races.csv";
String[] allData;
ArrayList<Election> allElections = new ArrayList(0);
PFont font;

void setup() {
  size(800, 600);
  background(115);
  smooth();
  font = loadFont("AmericanPurpose-48.vlw");

  allData = loadStrings(filename);
  parseData();
  //checkData();

  int renderYear = 2000;
  for (Election e:allElections) {
    if (e.electionYear == renderYear) {
      e.render();
    }
  }
}

void draw() {
}

void parseData() {

  // make the first Election so we have something to compare to
  init_Elections();
  //checkData();

  int[] years = int(allData[0].split(","));
  String[] names = allData[1].split(",");

  for (int column=3; column<years.length; column++) {
    int electionYear = years[column];

    // if the year is the same as the previous column, 
    // add this candidate to the last election in the Array List
    if (electionYear == years[column-1]) {
      Election thisElection = allElections.get(allElections.size()-1);
      Candidate thisCandidate = new Candidate(names[column], electionYear, thisElection.totalCandidates + 1);
      // for every row of data, match the candidate with the value for that row
      for (int i=2; i<allData.length; i++) {
        String[] thisRow = allData[i].split(",");
        String title = thisRow[0];
        int value = int(thisRow[column]);
        Category thisCategory = new Category(title, value);
        thisCandidate.categories.add(thisCategory);
      }
      thisElection.candidates.add(thisCandidate);
      thisElection.totalCandidates++;
    } 
    else {  // create a new election and add the first candidate
      Election thisElection = new Election(electionYear);
      Candidate thisCandidate = new Candidate(names[column], electionYear, 1);
      // for every row of data, match the candidate with the value for that row
      for (int i=2; i<allData.length; i++) {
        String[] thisRow = allData[i].split(",");
        String title = thisRow[0];
        int value = int(thisRow[column]);
        Category thisCategory = new Category(title, value);
        thisCandidate.categories.add(thisCategory);
      }
      thisElection.candidates.add(thisCandidate);
      allElections.add(thisElection);
    }
  }
}

void init_Elections() {
  int[] years = int(allData[0].split(","));
  String[] names = allData[1].split(",");

  int electionYear = years[1];
  Election firstElection = new Election(electionYear);

  Candidate firstCandidate = new Candidate(names[1], electionYear, 1);
  firstElection.candidates.add(firstCandidate);
  for (int i=2; i<allData.length; i++) {
    String[] thisRow = allData[i].split(",");
    String title = thisRow[0]; 
    int value = int(thisRow[1]); // same column as the name
    Category thisCategory = new Category(title, value);
    firstCandidate.categories.add(thisCategory);
  }
  Candidate secondCandidate = new Candidate(names[2], electionYear, 2);
  firstElection.candidates.add(secondCandidate);
  for (int i=2; i<allData.length; i++) {
    String[] thisRow = allData[i].split(",");
    String title = thisRow[0]; 
    int value = int(thisRow[2]);
    Category thisCategory = new Category(title, value);
    secondCandidate.categories.add(thisCategory);
  }
  allElections.add(firstElection);
}




void checkData() {  

  /* check all data for one election */
  //  int checkYear = 1952;
  //  
  //  for(Election e:allElections){
  //   if(e.electionYear == checkYear){
  //    println("Election Year= " + checkYear);
  //    for(Candidate c:e.candidates){
  //     println("<< " + c.name + " >>");
  //     for(Category cat:c.categories){
  //      println(cat.title + ": " + cat.value);
  //     }
  //     println(" ");
  //    }
  //   } 
  //  }

  /* check dates and names for all elections */
  for (Election e:allElections) {
    print("--------------");
    println(e.electionYear);
    for (Candidate c:e.candidates) {
      println("<< " + c.name + " >>");
      //      for (int i=0; i<c.categories.size(); i++) {
      //        Category thisCategory = c.categories.get(i);
      //        println(thisCategory.title + ": " + thisCategory.value);
      //      }
    }
    println(" ");
  }
}

