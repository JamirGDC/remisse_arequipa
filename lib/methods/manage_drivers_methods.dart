
import 'package:remisse_arequipa/models/online_nearby_drivers.dart';

class ManageDriversMethods
{
  static List<OnlineNearbyDrivers> nearbyOnlineDriversList = [];

  static void removeDriverFromList(String driverID)
  {
    int index = nearbyOnlineDriversList.indexWhere((driver) => driver.uidDriver == driverID);

    if(nearbyOnlineDriversList.isNotEmpty)
    {
      nearbyOnlineDriversList.removeAt(index);
    }
  }

  static void updateOnlineNearbyDriversLocation(OnlineNearbyDrivers nearbyOnlineDriverInformation)
  {
    int index = nearbyOnlineDriversList.indexWhere((driver) => driver.uidDriver == nearbyOnlineDriverInformation.uidDriver);

    nearbyOnlineDriversList[index].latDriver = nearbyOnlineDriverInformation.latDriver;
    nearbyOnlineDriversList[index].lngDriver = nearbyOnlineDriverInformation.lngDriver;
  }
}