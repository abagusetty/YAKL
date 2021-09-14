
#pragma once

template <class T, int rank, int myMem, int myStyle, int myAttr>
class ArrayBase {
public:

  typedef typename std::remove_const<T>::type type;

  T       * myData;         // Pointer to the flattened internal data
  index_t dimension[rank];  // Sizes of the 8 possible dimensions
  #ifdef YAKL_DEBUG
    char const * myname;    // Label for debug printing. Only stored if debugging is turned on
  #endif


  template <int theirRank, int theirStyle, int theirAttr>
  inline void deep_copy_to(Array<T,theirRank,memHost,theirStyle,theirAttr> &lhs) const {
    #ifdef YAKL_DEBUG
      if (this->totElems() != lhs.totElems()) {
        yakl_throw("ERROR: deep_copy_to with different number of elements");
      }
      if (this->myData == nullptr || lhs.myData == nullptr) {
        yakl_throw("ERROR: deep_copy_to with nullptr");
      }
    #endif
    if (myMem == memHost) {
      memcpy_host_to_host( lhs.myData , this->myData , this->totElems() );
    } else {
      memcpy_device_to_host( lhs.myData , this->myData , this->totElems() );
    }
  }


  template <int theirRank, int theirStyle, int theirAttr>
  inline void deep_copy_to(Array<T,theirRank,memDevice,theirStyle,theirAttr> &lhs) const {
    #ifdef YAKL_DEBUG
      if (this->totElems() != lhs.totElems()) {
        yakl_throw("ERROR: deep_copy_to with different number of elements");
      }
      if (this->myData == nullptr || lhs.myData == nullptr) {
        yakl_throw("ERROR: deep_copy_to with nullptr");
      }
    #endif
    if (myMem == memHost) {
      memcpy_host_to_device( lhs.myData , this->myData , this->totElems() );
    } else {
      memcpy_device_to_device( lhs.myData , this->myData , this->totElems() );
    }
  }


  /* ACCESSORS */
  YAKL_INLINE int get_rank() const {
    return rank;
  }
  YAKL_INLINE index_t get_totElems() const {
    index_t tot = this->dimension[0];
    for (int i=1; i<rank; i++) { tot *= this->dimension[i]; }
    return tot;
  }
  YAKL_INLINE index_t get_elem_count() const {
    return get_totElems();
  }
  YAKL_INLINE index_t totElems() const {
    return get_totElems();
  }
  YAKL_INLINE T *data() const {
    return this->myData;
  }
  YAKL_INLINE T *get_data() const {
    return this->myData;
  }
  YAKL_INLINE bool span_is_contiguous() const {
    return true;
  }
  YAKL_INLINE bool initialized() const {
    return this->myData != nullptr;
  }
  const char* label() const {
    #ifdef YAKL_DEBUG
      return this->myname;
    #else
      return "";
    #endif
  }


  /* OPERATOR<<
  Print the array. If it's 2-D, print a pretty looking matrix */
  inline friend std::ostream &operator<<(std::ostream& os, Array<T,rank,myMem,myStyle,myAttr> const &v) {
    #ifdef YAKL_DEBUG
      os << "For Array labeled: " << v.myname << "\n";
    #endif
    os << "Number of Dimensions: " << rank << "\n";
    os << "Total Number of Elements: " << v.totElems() << "\n";
    os << "Dimension Sizes: ";
    for (int i=0; i<rank; i++) {
      os << v.dimension[i] << ", ";
    }
    os << "\n";
    T *local = v.myData;
    if (myMem == memDevice) {
      local = new T[v.totElems()];
      memcpy_device_to_host( local , v.myData , v.totElems() );
    }
    for (index_t i=0; i<v.totElems(); i++) {
      os << local[i] << " ";
    }
    if (myMem == memDevice) {
      delete[] local;
    }
    os << "\n";
    return os;
  }


};
