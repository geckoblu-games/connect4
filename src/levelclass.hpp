#pragma once

#include <QObject>

class LevelClass {
  Q_GADGET
public:
  enum Value { Easy, Normal, Hard, Expert };
  Q_ENUM(Value)

private:
  explicit LevelClass(){};
};

typedef LevelClass::Value Level;
