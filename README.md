# NonClassicalLightNesi


## Running QuTip with MKL

There is a significant performance benefit in using NeSI's optimized MKL (Math Kernel Library) when 
solving the stated-state equation and selecting the "direct" method. Unfortunately, the QuTip version
bundled with the NeSI "Python" module is not aware that MKL is available on NeSI's mahuika platform.
Below are steps to coerce QuTiP to using MKL at runtime. 

### Create a Python virtual environment

Start by loading
```
module load Python
```
Then create a Python virtual environment
```
python -m venv /nesi/project/PROJECT_ID/qutipenv
```

Activate the environment
```
source /nesi/project/PROJECT_ID/qutipenv/bin/activate
```
and install additional packages, e.g.
```
pip install matplotlib
```
as needed.

To deactivate the environment, type
```
deactivate
```

### Install NeSI's MKL aware QuTip

```
git clone git@github.com:pletzer/qutip.git qutip-nesi
cd qutip-nesi
git fetch --all
git checkout qutip-4.7.X-nesi
```
Now build the package
```
pip install -e .
```
This version of QuTip will check if the environment variable "EBROOTIMKL" has been set and 
load the shared library "libmkl_rt.so" if it can find it under "$EBROOTIMKL". 
You don't need to set "$EBROOTIMKL" explicitly, as this variable
is automatically set when typing "module load imkl". 

If module "imkl" is not loaded, QuTip will revert to using the default, internal BLAS library. 

To check that QuTip uses NeSI's MKL
```
python -c "import qutip;qutip.about()"
```

### Load the imkl module 

In your slurm script, be sure to have
```
module load Python
module load imkl
source /nesi/project/PROJECT_ID/qutipenv/bin/activate
```

### Performance results 

Below are execution times to obtain the steady state solution on Mahuika milan partition using 4 cores (--cpus-per-task=4).

| QuTip version | Timing (s) |
|---------------|--------|
| default       | 2980   |
| NeSI          | 218    |

## How to run tests

In the top directory, type
```
pytest
```
If all tests pass you should see
```
tests/test_atoms_cavity.py .                                                                                                       [100%]

=========================================================== 1 passed in 2.20s ============================================================
```

## How to add new tests

Add your test scripts under the `tests/` directory. Each function should ideally test a feature. The name of the function 
should start with `test_`.

## Continuous integration

File `.github/workflows/ci.yml` instructs github to build the code (install Python and dependencies) and run the unit tests each time 
a change is pushed to the repository. The output of the tests can be found under the "Actions" tab, e.g. <https://github.com/aell060/NonClassicalLightNesi/actions>.

![CI results](https://github.com/aell060/NonClassicalLightNesi/actions/workflows/ci.yml/badge.svg)

