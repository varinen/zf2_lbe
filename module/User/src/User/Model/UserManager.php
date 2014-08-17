<?php
namespace User\Model;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class UserManager implements ServiceLocatorAwareInterface
{

    /**
     * @var ServiceLocatorInterface
     */
    protected $services;
    /**
     * Creates and fills the user entity identified by user identity
     *
     * @param $identity
     *
     * @return Entity\User
     */
    public function create($identity)
    {
        $user = $this->services->get('user-entity');
        $entityManager = $this->services->get('entity-manager');
        $user = $entityManager->getRepository(get_class($user))
            ->findOneByEmail($identity);

        return $user;
    }

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->services = $serviceLocator;
    }

    public function getServiceLocator()
    {
        return $this->services;
    }
}