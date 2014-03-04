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
    println(e.totalCandidates);
    println(" ");
  }
}
