class Flock {
  ArrayList<Mover> movers; // An ArrayList for all the boids

  Flock() {
    movers = new ArrayList<Mover>(); // Initialize the ArrayList
  }
  
  void run(ArrayList<Attractor> attractors) {
    for (Mover m : movers) {
      m.run(movers,attractors);  // Passing the entire list of boids to each boid individually
    }
  }

  void addMover(Mover m) {
    movers.add(m);
  }
  
  void removeMover(int i){
    movers.remove(i);
  }

}
