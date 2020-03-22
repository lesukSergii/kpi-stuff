#include <iostream>
#include "omp.h"
#include <windows.h>
#include <iostream>
#include "operations.h"
#include <ctime>
#include <clocale>

/**
 * Parallel and Distributed Computing
 * Laboratory work #3. C++. OpenMP: barriers, critical sections
 * Task: A = sort(Z)*e +(B�C)*(D*MO)
 * Koval Rostyslav IO-71
 */

using namespace std;

const int P = 6;
int N = 12;

int main()
{
	vector A = new int[N];
	vector B = new int[N];
	vector C = new int[N];
	vector D = new int[N];
	vector Z = new int[N];

	vector R = new int[N];
	matrix MO;
	int e = 0;
	int x = 0;

	const int H = N / P;

	void cs();

	omp_set_num_threads(P);

#pragma omp parallel
	{
		int tid = omp_get_thread_num();
		cout << "Task " << tid + 1 << " started" << endl;

		// �������� � ������ �1
		if (tid == 0) {
			MO = inputMatrix(1);
			Z = inputVector(1);
		}

		// �������� y ������ �3 
		if (tid == 2) {
			B = inputVector(1);
			e = 1;
		}

		// �������� � ������ �4
		if (tid == 3) {
			C = inputVector(1);
			D = inputVector(1);
		}

		//���� ��� ��� �����. ������������ �� �����
#pragma omp barrier

		//���������� 1:  RH = sort(ZH)
		for (int i = tid * H; i < (tid + 1) * H; i++){
			for (int j = tid * H; j < ((tid + 1) * H) - 1; j++){
				if (R[j + 1] < R[j]){
					int tmp = R[j + 1];
					R[j + 1] = R[j];
					R[j] = tmp;
				}
			}
		}

		//����. ������������� ��������� 1
#pragma omp barrier

		//���������� 2: N2H = mergeSort(RH, RH)
		if (tid == 0) {
			merge(0, H, H, 2 * H, R);
		}

		//���������� 2: N2H = mergeSort(RH, RH)
		if (tid == 2) {
			merge(2 * H, 3 * H, 3 * H, 4 * H, R);
		}

		//���������� 2: N2H = mergeSort(RH, RH)
		if (tid == 4) {
			merge(2 * H, 3 * H, 3 * H, 4 * H, R);
		}

		//����. ������������� ���������� 2
#pragma omp barrier
		if (tid == 0) {
			//���������� 3: Q = mergeSort(N2H, N2H)
			merge(0, 2 * H, 2 * H, 4 * H, R);
		}

		if (tid == 0) {
			//���������� 4: Z = mergeSort(Q, N2H)
			merge(0, 2 * H, 2 * H, 4 * H, R);
		}

		int xi = 0;
		//���������� 5: MXH = MOi*MKH; xi = DH*XH
		for (int i = tid * H; i < (tid + 1) * H; i++){
			xi += B[i] * C[i];
		}
		
		vector Di = new int[N];
		int ei = 0;
		//���������� 6: x = x + xi
#pragma omp_atomic
		{
			x += xi;
		}
		//����. ������������� ��������� 6
#pragma omp barrier

		//��������� xi = x
#pragma omp_atomic
		{
			xi = x;
		}
		//�������� ei = e 
#pragma omp_atomic
		{
			ei = e;
		}

		//�������� Di = D
#pragma omp critical(cs)
		{
			Di = copyVector(D);
		}

		//���������� 7: AH = ZH*ei + xi*Di*MOH
		vector tmpi = new int[N];
		for (int i = tid * H; i < (tid + 1) * H; i++) {
			tmpi[i] = 0;
			for (int j = 0; j < N; j++) {
				tmpi[i] += (Di[j] * MO[j][i]);
			}
		}
		for (int i = tid * H; i < (tid + 1) * H; i++) {
			A[i] = Z[i] * ei + xi * tmpi[i];
		}

		//����. �������i����� ���������� 7
#pragma omp barrier
		if (tid == 0){
			output(A);
		}
		cout << "Task " << tid + 1 << " ended" << endl;
	}
	getchar();
	return 0;
}
