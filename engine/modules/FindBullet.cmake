# - Try to find the Bullet physics engine
#
#  This module defines the following variables
#
#  BULLET_FOUND - Was bullet found
#  BULLET_INCLUDE_DIRS - the Bullet include directories
#  BULLET_LIBRARIES - Link to this, by default it includes
#                     all bullet components (Dynamics,
#                     Collision, LinearMath, & SoftBody)
#
#  This module accepts the following variables
#
#  BULLET_ROOT - Can be set to bullet install path or Windows build path
#

#=============================================================================
# Copyright 2009 Kitware, Inc.
# Copyright 2009 Philip Lowman <philip@yhbt.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

macro(_FIND_BULLET_LIBRARY _var)
  find_library(${_var}
     NAMES 
        ${ARGN}
     PATHS
	${ROGUE_REBORN_DIR}/physics/dep/bullet-2.77/msvc/2008/lib/Debug
     	${ROGUE_REBORN_DIR}/physics/dep/bullet-2.77/msvc/2008/lib/Release
     	${ROGUE_REBORN_DIR}/physics/dep/bullet-2.77/build/lib/Debug
     	${ROGUE_REBORN_DIR}/physics/dep/bullet-2.77/build/lib/Release
        ${BULLET_ROOT}
        ${BULLET_ROOT}/out/release8/libs
        ${BULLET_ROOT}/out/debug8/libs
	/usr/local/Cellar/bullet/2.77/lib
     PATH_SUFFIXES lib
     PATH_PREFIXES lib
  )
  mark_as_advanced(${_var})
endmacro()

macro(_BULLET_APPEND_LIBRARIES _list _release)
   set(_debug ${_release}_DEBUG)
   if(${_debug})
      set(${_list} ${${_list}} optimized ${${_release}} debug ${${_debug}})
   else()
      set(${_list} ${${_list}} ${${_release}})
   endif()
endmacro()

find_path(BULLET_INCLUDE_DIR NAMES btBulletCollisionCommon.h
  PATHS
    ${ROGUE_REBORN_DIR}/physics/dep/bullet-2.77/include
    ${ROGUE_REBORN_DIR}/physics/dep/bullet-2.77/src
    /usr/local/Cellar/bullet/2.77/include/bullet
    /usr/include/bullet
    /usr/local/include/bullet
    ${BULLET_ROOT}/include
    ${BULLET_ROOT}/src
)

# Find the libraries

_FIND_BULLET_LIBRARY(BULLET_DYNAMICS_LIBRARY        BulletDynamics)
_FIND_BULLET_LIBRARY(BULLET_DYNAMICS_LIBRARY_DEBUG  BulletDynamics_d)
_FIND_BULLET_LIBRARY(BULLET_COLLISION_LIBRARY       BulletCollision)
_FIND_BULLET_LIBRARY(BULLET_COLLISION_LIBRARY_DEBUG BulletCollision_d)
_FIND_BULLET_LIBRARY(BULLET_MATH_LIBRARY            LinearMath BulletMath)
_FIND_BULLET_LIBRARY(BULLET_MATH_LIBRARY_DEBUG      LinearMath_d BulletMath_d)
_FIND_BULLET_LIBRARY(BULLET_SOFTBODY_LIBRARY        BulletSoftBody)
_FIND_BULLET_LIBRARY(BULLET_SOFTBODY_LIBRARY_DEBUG  BulletSoftBody_d)


# handle the QUIETLY and REQUIRED arguments and set BULLET_FOUND to TRUE if 
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Bullet DEFAULT_MSG
    BULLET_DYNAMICS_LIBRARY BULLET_COLLISION_LIBRARY BULLET_MATH_LIBRARY
    BULLET_SOFTBODY_LIBRARY BULLET_INCLUDE_DIR)

set(BULLET_INCLUDE_DIRS ${BULLET_INCLUDE_DIR})
if(BULLET_FOUND)
   _BULLET_APPEND_LIBRARIES(BULLET_LIBRARIES BULLET_DYNAMICS_LIBRARY)
   _BULLET_APPEND_LIBRARIES(BULLET_LIBRARIES BULLET_COLLISION_LIBRARY)
   _BULLET_APPEND_LIBRARIES(BULLET_LIBRARIES BULLET_MATH_LIBRARY)
   _BULLET_APPEND_LIBRARIES(BULLET_LIBRARIES BULLET_SOFTBODY_LIBRARY)
endif()
