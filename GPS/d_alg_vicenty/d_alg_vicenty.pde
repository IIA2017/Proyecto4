// constants
const float pi=3.141593;
// WGS84 ellipsoid model
float a=6378137; //[m] minor oblate ellipsoid axis
float b=6356752.3142; //[m] major oblate ellipsoid axis
float f=(a-b)/a; // 1/298.257223563 [m] ellipsoid flattening
// Precision
float p=10e-12;  // Gives 0.5 mm of precision
// Variables
float L; // Longitude difference
// Initialization
float L2=2*pi;
void setup()
{
  // put your setup code here, to run once:

}

// COMO PASAR DE GRADOS MINUTOS SEGUNDOS A GRADOS O RADIANES DE TODA LA VIDA DE DIOS?

void loop(){
float sin_sigma;
float cos_sigma;
float sigma;
float sin_alpha;
float cos_alpha;
float cos_pow2_alpha;
float cos_2sigma_m;
float C;
float u_pow2;
float A;
float B;
float Asigma;
float s;
float alpha1;
float alpha2;

float fi1;
float fi2;
float l1;
float l2;

float U1=atan2((1-f)*tan(fi1)); // Reduced latitude 1
float U2=atan2((1-f)*tan(fi2)); // Reduced latitude 2

do{
  sin_sigma=sqrt((cos(U2)*cos(L))*(cos(U2)*cos(L))+(cos(U1)*sin(U2)-sin(U1)*cos(U2)*cos(L))*(cos(U1)*sin(U2)-sin(U1)*cos(U2)*cos(L)));
  cos_sigma=sin(U1)*sin(U2)+cos(U1)*cos(U2)*cos(L);
  sigma=atan2(sin_sigma,cos_sigma);
  sin_alpha=cos(U1)*cos(U2)*sin(L)/sin_sigma;
  cos_pow2_alpha=1-sin_alpha*sin_alpha;
  cos_2sigma_m=cos_sigma-2*sin(U1)*sin(U2)/(cos_alpha*cos_alpha);
  C=f/16*cos_alpha*cos_alpha*(4+f*(4-3*cos_alpha*cos_alpha));
  L2=L;
  L=L+(1-C)*f*sin_alpha*(sigma+C*sin_sigma*(cos_2sigma_m+C*cos_sigma*(-1+2*cos_2sigma_m*cos_2sigma_m))); // cos_2sigma_m=0 if the two points are contained in the equator
}while(abs(L-L2)>p);

u_pow2=cos_alpha*cos_alpha*(a*a-b*b)/(b*b);
A=1+u_pow2/16384*(4096+u_pow2*(-768+u_pow2*(320-175*u_pow2)));
B=u_pow2/1024*(256+u_pow2*(-128+u_pow2*(74-47*u_pow2)));
Asigma=B*sin_sigma*(cos_2sigma_m+B/4*(cos_sigma*(-1+2*cos_2sigma_m*cos_2sigma_m)-B/6*cos_2sigma_m*(-3+4*sin_sigma*sin_sigma)*(-3+4*cos_2sigma_m*cos_2sigma_m)));
s=b*A*(sigma-Asigma); // distance between the two points
alpha1=atan2(cos(U2)*sin(L),cos(U1)*sin(U2)-sin(U1)*cos(U2)*cos(L)); // Initial azimuth (from point 1 to point 2)
alpha2=atan2(cos(U1)*sin(L),-sin(U1)*cos(U2)+cos(U1)*sin(U2)*cos(L));// Final azimuth (from point 1 to point 2)
}
