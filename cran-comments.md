## v1.0.2

This is patch release with the only purpose of removing the C++11 specification
from package requirements (no longer needed as the current default is C++17).

## R CMD check results

0 errors | 0 warnings | 1 note

* checking DESCRIPTION meta-information ... NOTE
Author field differs from that derived from Authors@R
  Author:    'Valerio Gherardi [aut, cre] (ORCID: <https://orcid.org/0000-0002-8215-3013>)'
  Authors@R: 'Valerio Gherardi [aut, cre] (<https://orcid.org/0000-0002-8215-3013>)'
  
I wasn't able to identify the source of this issue, as I don't have separate 
Author and Authors@R fields. However, the issue looks innocuous.
