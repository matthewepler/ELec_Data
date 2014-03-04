import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class ELec_Data extends PApplet {

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

public void setup() {
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

public void draw() {
}

public void parseData() {

  // make the first Election so we have something to compare to
  init_Elections();
  //checkData();

  int[] years = PApplet.parseInt(allData[0].split(","));
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
        int value = PApplet.parseInt(thisRow[column]);
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
        int value = PApplet.parseInt(thisRow[column]);
        Category thisCategory = new Category(title, value);
        thisCandidate.categories.add(thisCategory);
      }
      thisElection.candidates.add(thisCandidate);
      allElections.add(thisElection);
    }
  }
}

public void init_Elections() {
  int[] years = PApplet.parseInt(allData[0].split(","));
  String[] names = allData[1].split(",");

  int electionYear = years[1];
  Election firstElection = new Election(electionYear);

  Candidate firstCandidate = new Candidate(names[1], electionYear, 1);
  firstElection.candidates.add(firstCandidate);
  for (int i=2; i<allData.length; i++) {
    String[] thisRow = allData[i].split(",");
    String title = thisRow[0]; 
    int value = PApplet.parseInt(thisRow[1]); // same column as the name
    Category thisCategory = new Category(title, value);
    firstCandidate.categories.add(thisCategory);
  }
  Candidate secondCandidate = new Candidate(names[2], electionYear, 2);
  firstElection.candidates.add(secondCandidate);
  for (int i=2; i<allData.length; i++) {
    String[] thisRow = allData[i].split(",");
    String title = thisRow[0]; 
    int value = PApplet.parseInt(thisRow[2]);
    Category thisCategory = new Category(title, value);
    secondCandidate.categories.add(thisCategory);
  }
  allElections.add(firstElection);
}




public void checkData() {  

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

class Candidate{
  
 String name;
 int elecYear;
 ArrayList<Category> categories = new ArrayList();
 int index;

 Candidate(String _name, int _year, int _index){
  name = _name;
  elecYear = _year;
  index = _index;
 } 
  
}
class Category{
  
  String title;
  float value;
  
  Category(String _title, int _value){
   title = _title; 
   value = _value;
  }
}
class Election {

  int electionYear;
  ArrayList<Candidate> candidates = new ArrayList();
  int totalCandidates;


  Election(int _year) {
    electionYear = _year;
    totalCandidates = 1;
  } 

  public void render() {
    // choose a category title and display it for each candidate

    // let's start easy and just make some circles. blue for democratic, red for republican
    // if there is a third candidate we'll fill them in with light grey    
    String searchTitle = "Women";
    int[] colors = {
      color(0, 0, 255), color(255, 0, 0), color(155)
    };
    noStroke();

    float x = width/2;
    float y = height/2;
    float renderRadius = 250;
    float hole = 0.65f*renderRadius;
    float start = radians(90);

    for (int i=0; i<totalCandidates; i++) {
      Candidate thisCandidate = candidates.get(i);
      for (int j=0; j<thisCandidate.categories.size(); j++) {
        Category thisCategory = thisCandidate.categories.get(j);
        if (thisCategory.title.equals(searchTitle)) {
          float renderValue = start + radians(thisCategory.value/100 * 360);
          fill(colors[i]); // the first candidate is always a Democrat
          arc(x, y, renderRadius, renderRadius, start, renderValue); 
          start = renderValue;
        }
      }
      textFont(font, 72);
      fill(240);
      if (i == 0) {
        textAlign(LEFT);
        text(thisCandidate.name, x - 300, y);
      } 
      else if (i == 1) {
        textAlign(RIGHT);
        text(thisCandidate.name, x + 300, y);
      } 
    }
    fill(115);
    ellipse(x, y, hole, hole);
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "ELec_Data" });
  }
}
