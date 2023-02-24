pragma circom 2.1.3;

/*This circuit template checks that c is the multiplication of a and b.*/  

template Multiplier () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;  
   signal output c;  

   // Constraints.  
   c <== a * b;  
}

component main = Multiplier();