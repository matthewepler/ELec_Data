/* 
 Historical Data Interface - Electrion Data 
 Matthew Epler 2012
 */

String filename = "US_Races.csv";
String[] allData;
ArrayList<Election> allElections = new ArrayList();
ArrayList<Candidate> allCandidates = new ArrayList();

float secWidth;
int graphTop;
int graphBottom;
int graphHeight;
int graphIndex;
float margin;

PFont nameFont;
PFont yearFont;

int renderYear = 2008;
String renderCategory = "Catholic";
int yearFontLarge = 50;
int yearFontSmall = 16;
int nameFontSize = 28;
int boxHeight = 80;
int backgroundCol = 200;

boolean displayMenu = false;

//_________________________________________________setup()______________________________
void setup() {
  size(1000, 800);
  smooth();
  nameFont = loadFont("Arial-Black-48.vlw");
  yearFont = loadFont("AppleGothic-48.vlw");

  allData = loadStrings(filename);
  parseData();
  //checkData();
  
  secWidth = width/(allElections.size()+1);
  graphTop = height - 120;
  graphBottom = height - 50;
  graphHeight = graphBottom - graphTop;
  margin = .04 * width;

}

//_________________________________________________draw()______________________________
void draw() {
  if(displayMenu == true){
   displayMenu(); 
  } else {
  background(backgroundCol);
  for (Election e:allElections) {
    if (e.electionYear == renderYear) {
      e.render(renderCategory);
    }
  }  
  noStroke();
  textFont(yearFont, yearFontLarge); 
// 
//  fill(25);
//  rect(0, margin - 20, textWidth("year" + "000"), 20);
//  textSize(yearFontSmall);
//  fill(255);
//  text("SEARCH TERM", 10, 36);
  
  // Category Box
  textSize(yearFontLarge);
  fill(255);
  rect(0, margin, textWidth(renderCategory)*1.25 + margin, boxHeight);
  fill(25);
  text("\"" + renderCategory + "\"", margin/2, margin + boxHeight - yearFontLarge/2);
  
  // Year Box
  fill(25);
  rect(0, boxHeight + margin, textWidth("year" + "000"), boxHeight); // this will be obsolete in the year 10,000
  fill(255);
  text(renderYear, margin, margin + boxHeight*2 - yearFontLarge/2);
  
  // Key
  fill(#0D3574);
  rect(secWidth, height - 230, 20, 20);
  fill(#FF3434);
  rect(secWidth, height - 200, 20, 20);
  fill(#F2F0F0);
  rect(secWidth, height - 170, 20, 20);
  fill(255);
  textSize(yearFontSmall);
  text("Democrat", secWidth + 30, height - 214);
  text("Republican", secWidth + 30, height - 183);
  text("Other", secWidth + 30, height - 153);
 
  renderGraph(renderCategory);
  
} 
}

//_________________________________________________parseData()______________________________
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
      allCandidates.add(thisCandidate);
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
      thisElection.totalCandidates = 1;
      thisElection.index = allElections.size();
      allCandidates.add(thisCandidate);
    }
  }
}

//_________________________________________________initElections()______________________________
void init_Elections() {
  int[] years = int(allData[0].split(","));
  String[] names = allData[1].split(",");

  int electionYear = years[1];
  Election firstElection = new Election(electionYear);
  firstElection.index = 1;

  Candidate firstCandidate = new Candidate(names[1], electionYear, 1);
  firstElection.candidates.add(firstCandidate);
  for (int i=2; i<allData.length; i++) {
    String[] thisRow = allData[i].split(",");
    String title = thisRow[0]; 
    int value = int(thisRow[1]); // same column as the name
    Category thisCategory = new Category(title, value);
    firstCandidate.categories.add(thisCategory);
  }
  allCandidates.add(firstCandidate);
  firstCandidate.index = 1;

  Candidate secondCandidate = new Candidate(names[2], electionYear, 2);
  firstElection.candidates.add(secondCandidate);
  for (int i=2; i<allData.length; i++) {
    String[] thisRow = allData[i].split(",");
    String title = thisRow[0]; 
    int value = int(thisRow[2]);
    Category thisCategory = new Category(title, value);
    secondCandidate.categories.add(thisCategory);
  }
  allCandidates.add(secondCandidate);
  secondCandidate.index = 2;
  firstElection.totalCandidates = 2;
  firstElection.index = 1;
  allElections.add(firstElection);
}

//_________________________________________________renderGraph()______________________________
void renderGraph(String _category) {
  int demCounter = 0;
  int repCounter = 0;
  float[] democrats = new float[allElections.size()];
  float[] republicans = new float[allElections.size()];
  
  ArrayList<Election> others = new ArrayList();  
  for(Election e:allElections){
   if(e.totalCandidates > 2){
    others.add(e); 
  }
  }

  for (int i=allElections.size()-1; i>=0; i--) {
    Election thisElection = allElections.get(i);
    for (int j=0; j<thisElection.totalCandidates; j++) {
      if (j+1 == 1) {
       Candidate thisCandidate = thisElection.candidates.get(j);      
        for (Category cat:thisCandidate.categories) {
          if (cat.title.equals(_category)) {
            democrats[demCounter] = cat.value;
            demCounter++;
          }
        }
      } 
      else if (j+1 == 2) {
        Candidate thisCandidate = thisElection.candidates.get(j); 
        for (Category cat:thisCandidate.categories) {
          if (cat.title.equals(_category)) {
            republicans[repCounter] = cat.value; 
            repCounter++;
          }
        }
      } 
    }
  }
  
  // draw flags and marker lines
  for(int i=0; i<allElections.size(); i++){
   Election thisElection = allElections.get(i);
   float maxValue = max(democrats[i], republicans[i]);
   maxValue = map(maxValue, 0, 100, 0, graphHeight);
   stroke(255);
   strokeWeight(1);
   line(secWidth*thisElection.index, graphBottom, secWidth*thisElection.index, graphBottom - maxValue);
   thisElection.renderFlag(i);   
  }
  
  
  // draw the lines
  strokeWeight(3);
  noFill();
  beginShape(); // for Dems
  stroke(#0D3574);
  for (int i=0; i<democrats.length; i++) {
    float thisValue = map(democrats[i], 0, 100, 0, graphHeight);
    vertex(secWidth*(i+1), graphBottom - thisValue);
    ellipse(secWidth*(i+1), graphBottom - thisValue, 5, 5);
  }
  endShape();

  beginShape(); // for Repubs
  stroke(#FF3434);
  for (int i=0; i<republicans.length; i++) {
    float thisValue = map(republicans[i], 0, 100, 0, graphHeight);
    vertex(secWidth*(i+1), graphBottom - thisValue);
    ellipse(secWidth*(i+1), graphBottom - thisValue, 5, 5);
  }
  endShape();
  
  // bottom line
  strokeWeight(5);
  stroke(25);
  line(secWidth, graphBottom, width - secWidth, graphBottom);
  
  // ellipses for "Other" Candidates
  stroke(#F2F0F0); 
  strokeWeight(2); 
  for(int i=0; i<others.size(); i++){
   Election thisElection = others.get(i);
   Candidate thisCandidate = thisElection.candidates.get(2);
   for(Category cat:thisCandidate.categories){
    if(cat.title.equals(_category)){
     float thisValue = map(cat.value, 0, 100, 0, graphHeight);
     fill(#F2F0F0);
     ellipse(width - secWidth*thisElection.index - 8, graphBottom - thisValue, 5, 5);
    } 
   }
  }
}

//_________________________________________________mouseReleased()______________________________
void mouseReleased(){
  for(int i=1; i<allElections.size()+1; i++){
    if(mouseX > secWidth*i - secWidth/2 && mouseX < secWidth*(i+1) - secWidth/2 && mouseY > graphTop && displayMenu != true){
      Election thisElection = allElections.get(allElections.size()-i);
      renderYear = thisElection.electionYear;
    }
  }
  
  if(mouseY < 100 && mouseX < renderCategory.length()*60){
  displayMenu = !displayMenu;
  } 

}


//_________________________________________________displayMenu()______________________________
void displayMenu(){ 
 float heightTracker = margin + boxHeight;
 int rowCounter = 0;
 int boxWidth = 220;

 for(int i=2; i<allData.length; i++){
  textSize(50);
  float boxX = textWidth("year" + "000") + (rowCounter * boxWidth) ;
  textSize(16);
  String[] thisRow = allData[i].split(",");
  strokeWeight(1);
  
  if(mouseX > boxX && mouseX < boxX + 200 && mouseY > heightTracker && mouseY < heightTracker + 20){
  fill(255);  
  rect(boxX, heightTracker, boxWidth, 20);
  fill(0);  
  text(thisRow[0], boxX+5, heightTracker + 16);
   if(mousePressed){
    renderCategory = thisRow[0];
    displayMenu = false; 
   }
  } else {
  fill(0);
  rect(boxX, heightTracker, boxWidth, 20);
  fill(255);
  text(thisRow[0], boxX+5, heightTracker + 16);
  }
  
  

  heightTracker += 20;
  
  if(heightTracker > height - 160){
   heightTracker = margin + boxHeight;
   rowCounter ++; 
  }
 }
}





