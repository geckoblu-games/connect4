#ifndef MOVE_HPP
#define MOVE_HPP

#include <QJsonObject>

class Move
{
public:
    int column;
    int row;

    const QJsonObject toJSon() {
        return QJsonObject{
            {"column", column},
            {"row", row}
        };
    }
};

#endif // MOVE_HPP
