<?php
namespace User\Service\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

use Doctrine\ORM\Tools\Setup;
use Doctrine\ORM\EntityManager as DoctrineEntityManager;
use Doctrine\Common\EventArgs;

class EntityManager implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $config = $serviceLocator->get('config');

        //ote the difference between database config parameters in Doctrine and ZF2
        $doctrineDbConfig = (array) $config['db'];
        $doctrineDbConfig['driver'] = strtolower()
    }
}