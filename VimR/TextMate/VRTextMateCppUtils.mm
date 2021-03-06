/**
 * Tae Won Ha — @hataewon
 *
 * http://taewon.de
 * http://qvacua.com
 *
 * See LICENSE
 */

#include "VRTextMateCppUtils.h"
#include <numeric>


/**
* Frameworks/io/src/path.mm
* v2.0-alpha.9537
*/
size_t count_slashes(std::string const &s1, std::string const &s2) {
  auto s1First = s1.rbegin(), s1Last = s1.rend();
  auto s2First = s2.rbegin(), s2Last = s2.rend();
  while (s1First != s1Last && s2First != s2Last) {
    if (*s1First != *s2First)
      break;
    ++s1First, ++s2First;
  }
  return (size_t) std::count(s1.rbegin(), s1First, '/');
}

/**
* Frameworks/io/src/path.mm
* v2.0-alpha.9537
*/
std::vector<size_t> disambiguate(std::vector<std::string> const &paths) {
  std::vector<size_t> v(paths.size());
  std::iota(v.begin(), v.end(), 0);

  std::sort(v.begin(), v.end(), [&paths](size_t const &lhs, size_t const &rhs) -> bool {
    auto s1First = paths[lhs].rbegin(), s1Last = paths[lhs].rend();
    auto s2First = paths[rhs].rbegin(), s2Last = paths[rhs].rend();
    while (s1First != s1Last && s2First != s2Last) {
      if (*s1First < *s2First)
        return true;
      else if (*s1First != *s2First)
        return false;
      ++s1First, ++s2First;
    }
    return s1First == s1Last && s2First != s2Last;
  });

  std::vector<size_t> levels(paths.size());
  for (size_t i = 0; i < v.size();) {
    std::string const &current = paths[v[i]];
    size_t above = 0, below = 0;

    if (i != 0)
      above = count_slashes(current, paths[v[i - 1]]);

    size_t j = i;
    while (j < v.size() && current == paths[v[j]])
      ++j;
    if (j < v.size())
      below = count_slashes(current, paths[v[j]]);

    for (; i < j; ++i)
      levels[v[i]] = std::max(above, below);
  }

  return levels;
}
