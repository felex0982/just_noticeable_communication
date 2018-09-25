class Silhoutte {
  ArrayList<Attractor> attractors; 
  
  Silhoutte() {
    attractors = new ArrayList<Attractor>(); // Initialize the ArrayList
  }
  
  void run(){
     for(Attractor a : attractors){
     a.run();
     }
  }

  void addAttractor(Attractor a) {
    attractors.add(a);
  }
  
  void clearAttractors(){
    for(int i = attractors.size() - 1; i >= 0; i--){
       attractors.remove(i);
     }
  }
  
  ArrayList<Attractor> getAttractors(){
  return attractors;
  }
  
  int getListCount(){
  return attractors.size();
  }

}