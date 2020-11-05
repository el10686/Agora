#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>

int64_t gcd(int64_t a, int64_t b)
{
	if(b == 0)
		return a;
	else
		return gcd(b, a % b);
}

void fill_array(FILE *fp, int64_t *buff, int n)
{
	int i,ret;

	for (i=0; i<n; i++)
	{
		ret = fscanf(fp, "%"PRId64, &buff[i]);
		if (ret != 1) 
		{
			printf("Error: fscanf either reached EOF without reading, or read something not expected");
			return;
		}
	}
}

void calculate (int64_t *buff, int n) 
{
	int64_t i, *ekp_right, *ekp_left, ekp_final;
	int pos;
	
	ekp_right = (int64_t *) malloc(sizeof(int64_t) * n);
	if (ekp_right == NULL)
	{
		perror("Error: ");
		return;
	}
	
	ekp_right[0] = buff[0];
	for(i=1; i<=n-1; i++)
	{
		ekp_right[i] = ekp_right[i-1]/gcd(buff[i], ekp_right[i-1]) * buff[i];
	}
	
	ekp_left = (int64_t *) malloc(sizeof(int64_t) * n);
	if (ekp_left == NULL)
	{
		perror("Error: ");
		return;
	}

	ekp_left[n-1] = buff[n-1];
	for(i=n-2; i>=0; i--)
	{
		ekp_left[i] = ekp_left[i+1]/gcd(ekp_left[i+1], buff[i]) * buff[i];
	}
	/*
	for(i=0; i<n; i++)
		printf("%"PRId64 "% "PRId64 "% "PRId64 "\n", ekp_right[i], ekp_left[i], buff[i]);
	*/
	ekp_final = ekp_right[n-2];
	pos = n;
	
	for(i=1; i<n-1; i++)
	{
		int64_t temp;
		
		temp = ekp_right[i-1]/gcd(ekp_right[i-1], ekp_left[i+1]) * ekp_left[i+1]; 
		
		if (temp < ekp_final)
		{
			ekp_final = temp;
			pos = i+1; 
		}
	}
	
	if(ekp_left[1] < ekp_final)
	{
		ekp_final = ekp_left[1];
		pos = 1;
	}

	if(ekp_final == ekp_right[n-1]) 
		pos = 0;

	printf("%"PRId64 " %d\n", ekp_final, pos);

	free(ekp_right);
	free(ekp_left);
}

int main(int argc, char **argv) 
{ 
	if (argc != 2) 
	{	
		printf("Usage: ./agora text_file\n");
		return -1;
	}
	
	FILE *fp;	
	int n,ret;
	int64_t *buff;
	
	fp = fopen(argv[1], "r");
	if (fp == NULL)
	{
		perror("Error: ");
		return -1;
	}
	
	ret = fscanf(fp, "%d", &n);
	if (ret != 1) 
	{
		printf("Error: fscanf either reached EOF without reading, or read something not expected");
		return -1;
	}

	buff =(int64_t *) malloc(sizeof(int64_t) * n);
	if (buff == NULL)
	{
		perror("Error: ");
		return -1;
	}

	fill_array(fp, buff, n);
	fclose(fp);

	calculate(buff, n);
	
	free(buff);

	
	return 0;
} 
